import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import type { Language, LikedQuestionRow } from "@/lib/types/database";

export async function GET() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { data: likes, error } = await supabase
    .from("question_likes")
    .select("question_id, created_at")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  if (!likes?.length) {
    return NextResponse.json({ questions: [] });
  }

  const questionIds = likes.map((row) => row.question_id);
  const { data: questionRows, error: questionsError } = await supabase
    .from("questions")
    .select("id, question_stem, language, difficulty, topic_tags")
    .in("id", questionIds)
    .eq("status", "published");

  if (questionsError) {
    return NextResponse.json({ error: questionsError.message }, { status: 500 });
  }

  const questionById = new Map(
    (questionRows ?? []).map((q) => [q.id as string, q]),
  );

  const questions: LikedQuestionRow[] = [];
  for (const like of likes) {
    const q = questionById.get(like.question_id);
    if (!q) continue;
    questions.push({
      question_id: like.question_id,
      liked_at: like.created_at,
      question_stem: q.question_stem,
      language: q.language as Language,
      difficulty: q.difficulty,
      topic_tags: q.topic_tags ?? [],
    });
  }

  return NextResponse.json({ questions });
}

export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json().catch(() => ({}));
  const questionId =
    typeof body.question_id === "string" ? body.question_id : "";

  if (!questionId) {
    return NextResponse.json({ error: "question_id is required" }, { status: 400 });
  }

  const { data: question } = await supabase
    .from("questions")
    .select("id")
    .eq("id", questionId)
    .eq("status", "published")
    .maybeSingle();

  if (!question) {
    return NextResponse.json({ error: "Question not found" }, { status: 404 });
  }

  const { error } = await supabase.from("question_likes").insert({
    user_id: user.id,
    question_id: questionId,
  });

  if (error) {
    if (error.code === "23505") {
      return NextResponse.json({ liked: true });
    }
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ liked: true });
}

export async function DELETE(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json().catch(() => ({}));
  const questionId =
    typeof body.question_id === "string" ? body.question_id : "";

  if (!questionId) {
    return NextResponse.json({ error: "question_id is required" }, { status: 400 });
  }

  const { error } = await supabase
    .from("question_likes")
    .delete()
    .eq("user_id", user.id)
    .eq("question_id", questionId);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ liked: false });
}
