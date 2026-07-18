import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { computePoints, computeStreak } from "@/lib/scoring";
import type { Difficulty, Language, Question } from "@/lib/types/database";

export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const questionId = body.question_id as string | undefined;
  const selected = body.selected_option_index as number | undefined;
  const timeTakenMs =
    typeof body.time_taken_ms === "number" ? body.time_taken_ms : null;

  if (!questionId || typeof selected !== "number") {
    return NextResponse.json(
      { error: "question_id and selected_option_index are required" },
      { status: 400 },
    );
  }

  const { data: question, error: qError } = await supabase
    .from("questions")
    .select("*")
    .eq("id", questionId)
    .eq("status", "published")
    .single();

  if (qError || !question) {
    return NextResponse.json({ error: "Question not found" }, { status: 404 });
  }

  const q = question as Question;
  const isCorrect = selected === q.correct_option_index;
  const pointsAwarded = computePoints(isCorrect, q.difficulty as Difficulty);

  const { error: attemptError } = await supabase
    .from("question_attempts")
    .insert({
      user_id: user.id,
      question_id: questionId,
      selected_option_index: selected,
      is_correct: isCorrect,
      time_taken_ms: timeTakenMs,
      points_awarded: pointsAwarded,
    });

  if (attemptError) {
    return NextResponse.json({ error: attemptError.message }, { status: 500 });
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("total_points, daily_streak, last_active_at")
    .eq("id", user.id)
    .single();

  const now = new Date();
  const nextStreak = computeStreak(
    profile?.daily_streak ?? 0,
    profile?.last_active_at ?? null,
    now,
  );

  await supabase
    .from("profiles")
    .update({
      total_points: (profile?.total_points ?? 0) + pointsAwarded,
      daily_streak: nextStreak,
      last_active_at: now.toISOString(),
    })
    .eq("id", user.id);

  const topics = q.topic_tags?.length ? q.topic_tags : ["general"];
  for (const topic of topics) {
    const { data: existing } = await supabase
      .from("user_stats")
      .select("*")
      .eq("user_id", user.id)
      .eq("language", q.language)
      .eq("topic", topic)
      .eq("difficulty", q.difficulty)
      .maybeSingle();

    const answered = (existing?.questions_answered ?? 0) + 1;
    const correct = (existing?.questions_correct ?? 0) + (isCorrect ? 1 : 0);
    const accuracy = correct / answered;

    if (existing) {
      await supabase
        .from("user_stats")
        .update({
          questions_answered: answered,
          questions_correct: correct,
          accuracy,
        })
        .eq("user_id", user.id)
        .eq("language", q.language as Language)
        .eq("topic", topic)
        .eq("difficulty", q.difficulty as Difficulty);
    } else {
      await supabase.from("user_stats").insert({
        user_id: user.id,
        language: q.language,
        topic,
        difficulty: q.difficulty,
        questions_answered: answered,
        questions_correct: correct,
        accuracy,
      });
    }
  }

  return NextResponse.json({
    is_correct: isCorrect,
    correct_option_index: q.correct_option_index,
    points_awarded: pointsAwarded,
    explanation: q.explanation,
    thought_process: q.thought_process,
    daily_streak: nextStreak,
  });
}
