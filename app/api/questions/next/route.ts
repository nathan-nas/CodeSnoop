import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { resolveNextQuestion } from "@/lib/questions/next-question";
import type { Language } from "@/lib/types/database";

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
  const excludeId = searchParams.get("exclude");
  const questionId = searchParams.get("question_id");

  const { data: profile } = await supabase
    .from("profiles")
    .select("preferred_languages, preferred_topics")
    .eq("id", user.id)
    .single();

  const languages: Language[] =
    languageParam === "java" ||
    languageParam === "javascript" ||
    languageParam === "aem"
      ? [languageParam]
      : ((profile?.preferred_languages as Language[] | null)?.length
          ? (profile!.preferred_languages as Language[])
          : ["javascript", "java", "aem"]);

  const preferredTopics =
    (profile?.preferred_topics as string[] | null)?.filter(Boolean) ?? [];

  const { data: attempts } = await supabase
    .from("question_attempts")
    .select("question_id")
    .eq("user_id", user.id);

  const answeredIds = new Set((attempts ?? []).map((a) => a.question_id));

  try {
    const resolved = await resolveNextQuestion(supabase, {
      userId: user.id,
      languages,
      preferredTopics,
      answeredIds,
      topic,
      excludeId,
      questionId,
    });

    if (!resolved) {
      return NextResponse.json(
        { error: "No questions available", question: null },
        { status: 404 },
      );
    }

    return NextResponse.json({
      question: resolved.question,
      liked: resolved.meta.liked ?? false,
      share: resolved.meta.share ?? null,
    });
  } catch (e) {
    const message = e instanceof Error ? e.message : "Query failed";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
