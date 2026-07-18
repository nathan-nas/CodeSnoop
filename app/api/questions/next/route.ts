import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import type { Language, PublicQuestion, Question } from "@/lib/types/database";

export async function GET(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { searchParams } = new URL(request.url);
  const topic = searchParams.get("topic");
  const languageParam = searchParams.get("language");

  const { data: profile } = await supabase
    .from("profiles")
    .select("preferred_languages")
    .eq("id", user.id)
    .single();

  const languages: Language[] =
    languageParam === "java" || languageParam === "javascript"
      ? [languageParam]
      : ((profile?.preferred_languages as Language[] | null)?.length
          ? (profile!.preferred_languages as Language[])
          : ["javascript", "java"]);

  const { data: attempts } = await supabase
    .from("question_attempts")
    .select("question_id")
    .eq("user_id", user.id);

  const answeredIds = new Set((attempts ?? []).map((a) => a.question_id));

  let query = supabase
    .from("questions")
    .select("*")
    .eq("status", "published")
    .in("language", languages)
    .order("created_at", { ascending: true })
    .limit(50);

  if (topic) {
    query = query.contains("topic_tags", [topic]);
  }

  const { data: questions, error } = await query;

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  const pool = (questions as Question[] | null) ?? [];
  let next =
    pool.find((q) => !answeredIds.has(q.id)) ??
    pool[Math.floor(Math.random() * pool.length)] ??
    null;

  if (!next) {
    return NextResponse.json(
      { error: "No questions available", question: null },
      { status: 404 },
    );
  }

  const {
    correct_option_index: _c,
    explanation: _e,
    thought_process: _t,
    ...publicQuestion
  } = next;

  return NextResponse.json({
    question: publicQuestion as PublicQuestion,
  });
}
