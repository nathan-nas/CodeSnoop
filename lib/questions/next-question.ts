import type { SupabaseClient } from "@supabase/supabase-js";
import type {
  Language,
  PublicQuestion,
  PublicQuestionMeta,
  Question,
} from "@/lib/types/database";

export function toPublicQuestion(q: Question): PublicQuestion {
  const {
    correct_option_index: _c,
    explanation: _e,
    thought_process: _t,
    ...publicQuestion
  } = q;
  return publicQuestion;
}

export function pickFromPool(
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

type ShareRow = {
  id: string;
  question_id: string;
  sender_display_name: string | null;
};

export async function fetchPendingShare(
  supabase: SupabaseClient,
  userId: string,
  answeredIds: Set<string>,
  excludeId?: string | null,
): Promise<{ question: Question; share: PublicQuestionMeta["share"] } | null> {
  const { data: shares, error } = await supabase
    .from("question_shares")
    .select("id, question_id, sender_display_name")
    .eq("recipient_id", userId)
    .is("attempted_at", null)
    .order("created_at", { ascending: true });

  if (error || !shares?.length) return null;

  for (const row of shares as ShareRow[]) {
    if (excludeId && row.question_id === excludeId) continue;
    if (answeredIds.has(row.question_id)) continue;

    const { data: question } = await supabase
      .from("questions")
      .select("*")
      .eq("id", row.question_id)
      .eq("status", "published")
      .maybeSingle();

    if (!question) continue;

    return {
      question: question as Question,
      share: {
        id: row.id,
        sender_name: row.sender_display_name ?? "A friend",
      },
    };
  }

  return null;
}

export async function fetchQuestionById(
  supabase: SupabaseClient,
  questionId: string,
): Promise<Question | null> {
  const { data } = await supabase
    .from("questions")
    .select("*")
    .eq("id", questionId)
    .eq("status", "published")
    .maybeSingle();

  return (data as Question | null) ?? null;
}

export async function fetchQuestionPool(
  supabase: SupabaseClient,
  languages: Language[],
  opts: { topic?: string | null; overlaps?: string[] },
): Promise<Question[]> {
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

export async function isQuestionLiked(
  supabase: SupabaseClient,
  userId: string,
  questionId: string,
): Promise<boolean> {
  const { data } = await supabase
    .from("question_likes")
    .select("question_id")
    .eq("user_id", userId)
    .eq("question_id", questionId)
    .maybeSingle();

  return Boolean(data);
}

export async function resolveNextQuestion(
  supabase: SupabaseClient,
  opts: {
    userId: string;
    languages: Language[];
    preferredTopics: string[];
    answeredIds: Set<string>;
    topic?: string | null;
    excludeId?: string | null;
    questionId?: string | null;
  },
): Promise<{ question: PublicQuestion; meta: PublicQuestionMeta } | null> {
  const {
    userId,
    languages,
    preferredTopics,
    answeredIds,
    topic,
    excludeId,
    questionId,
  } = opts;

  if (questionId) {
    const specific = await fetchQuestionById(supabase, questionId);
    if (!specific) return null;

    const liked = await isQuestionLiked(supabase, userId, specific.id);
    return {
      question: toPublicQuestion(specific),
      meta: { liked },
    };
  }

  if (!topic) {
    const shared = await fetchPendingShare(
      supabase,
      userId,
      answeredIds,
      excludeId,
    );
    if (shared) {
      const liked = await isQuestionLiked(
        supabase,
        userId,
        shared.question.id,
      );
      return {
        question: toPublicQuestion(shared.question),
        meta: { liked, share: shared.share },
      };
    }
  }

  let pool: Question[];

  if (topic) {
    pool = await fetchQuestionPool(supabase, languages, { topic });
  } else if (preferredTopics.length > 0) {
    pool = await fetchQuestionPool(supabase, languages, {
      overlaps: preferredTopics,
    });
    const nextPreferred = pickFromPool(pool, answeredIds, excludeId);
    if (nextPreferred && !answeredIds.has(nextPreferred.id)) {
      const liked = await isQuestionLiked(supabase, userId, nextPreferred.id);
      return {
        question: toPublicQuestion(nextPreferred),
        meta: { liked },
      };
    }
    pool = await fetchQuestionPool(supabase, languages, {});
  } else {
    pool = await fetchQuestionPool(supabase, languages, {});
  }

  const next = pickFromPool(pool, answeredIds, excludeId);
  if (!next) return null;

  const liked = await isQuestionLiked(supabase, userId, next.id);
  return {
    question: toPublicQuestion(next),
    meta: { liked },
  };
}
