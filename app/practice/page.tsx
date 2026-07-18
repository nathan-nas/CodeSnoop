import Link from "next/link";
import { redirect } from "next/navigation";
import { PracticeSession } from "@/components/practice-session";
import { SiteHeader } from "@/components/site-header";
import { requireProfile } from "@/lib/auth";
import { highlightCode } from "@/lib/highlight";
import type { Language, PublicQuestion, Question } from "@/lib/types/database";

export default async function PracticePage() {
  const { supabase, profile, user } = await requireProfile();

  if (!profile.onboarding_completed) {
    redirect("/setup");
  }

  const languages: Language[] =
    profile.preferred_languages?.length > 0
      ? profile.preferred_languages
      : ["javascript", "java"];

  const preferredTopics = profile.preferred_topics?.filter(Boolean) ?? [];

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

  if (preferredTopics.length > 0) {
    query = query.overlaps("topic_tags", preferredTopics);
  }

  let { data: questions } = await query;
  let pool = (questions as Question[] | null) ?? [];
  let next =
    pool.find((q) => !answeredIds.has(q.id)) ?? null;

  if (!next && preferredTopics.length > 0) {
    const fallback = await supabase
      .from("questions")
      .select("*")
      .eq("status", "published")
      .in("language", languages)
      .order("created_at", { ascending: true })
      .limit(50);
    pool = (fallback.data as Question[] | null) ?? [];
    next = pool.find((q) => !answeredIds.has(q.id)) ?? pool[0] ?? null;
  } else if (!next) {
    next = pool[0] ?? null;
  }

  let publicQuestion: PublicQuestion | null = null;
  let html = "";

  if (next) {
    const {
      correct_option_index: _c,
      explanation: _e,
      thought_process: _t,
      ...rest
    } = next;
    publicQuestion = rest;
    html = await highlightCode(
      next.snippet_code,
      next.snippet_language || next.language,
    );
  }

  return (
    <div className="relative min-h-screen">
      <div className="pointer-events-none absolute inset-0 grid-noise opacity-30" />
      <SiteHeader
        right={
          <div className="flex items-center gap-3">
            <Link
              href="/dashboard"
              className="text-sm text-[var(--ink-muted)] hover:text-[var(--ink)]"
            >
              Dashboard
            </Link>
            <Link
              href="/profile"
              className="text-sm font-medium text-[var(--ink)] hover:text-[var(--accent)]"
            >
              Profile
            </Link>
          </div>
        }
      />
      <main className="relative z-10 mx-auto max-w-3xl px-6 pb-20 md:px-10">
        <h1 className="font-[family-name:var(--font-display)] text-3xl tracking-tight md:text-4xl">
          Practice
        </h1>
        <p className="mt-1 text-[var(--ink-muted)]">
          Read carefully. Pick an answer. Learn the why.
        </p>
        <div className="mt-8">
          <PracticeSession
            initialQuestion={publicQuestion}
            initialHtml={html}
          />
        </div>
      </main>
    </div>
  );
}
