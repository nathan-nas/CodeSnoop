import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import type { Language, PublicQuestion, Question } from "@/lib/types/database";

function toPublic(q: Question): PublicQuestion {
  const {
    correct_option_index: _c,
    explanation: _e,
    thought_process: _t,
    ...publicQuestion
  } = q;
  return publicQuestion;
}

function pickNext(
  pool: Question[],
  answeredIds: Set<string>,
  excludeId?: string | null,
): Question | null {
  const candidates = excludeId
    ? pool.filter((q) => q.id !== excludeId)
    : pool;

  return (
    candidates.find((q) => !answeredIds.has(q.id)) ??
    candidates[Math.floor(Math.random() * candidates.length)] ??
    null
  );
}

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

  async function fetchPool(opts: {
    topic?: string | null;
    overlaps?: string[];
  }) {
    let query = supabase
      .from("questions")
      .select("*")
      .eq("status", "published")
      .in("language", languages)
      .order("created_at", { ascending: true })
      .limit(50);

    if (opts.topic) {
      query = query.contains("topic_tags", [opts.topic]);
    } else if (opts.overlaps && opts.overlaps.length > 0) {
      query = query.overlaps("topic_tags", opts.overlaps);
    }

    const { data, error } = await query;
    if (error) throw new Error(error.message);
    return (data as Question[] | null) ?? [];
  }

  try {
    let pool: Question[];

    if (topic) {
      pool = await fetchPool({ topic });
    } else if (preferredTopics.length > 0) {
      pool = await fetchPool({ overlaps: preferredTopics });
      const nextPreferred = pickNext(pool, answeredIds, excludeId);
      if (nextPreferred && !answeredIds.has(nextPreferred.id)) {
        return NextResponse.json({ question: toPublic(nextPreferred) });
      }
      // Fall back so practice never goes empty when prefs are exhausted.
      pool = await fetchPool({});
    } else {
      pool = await fetchPool({});
    }

    const next = pickNext(pool, answeredIds, excludeId);
    if (!next) {
      return NextResponse.json(
        { error: "No questions available", question: null },
        { status: 404 },
      );
    }

    return NextResponse.json({ question: toPublic(next) });
  } catch (e) {
    const message = e instanceof Error ? e.message : "Query failed";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
