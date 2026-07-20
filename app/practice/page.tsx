import Link from "next/link";
import { redirect } from "next/navigation";
import { PracticeSession } from "@/components/practice-session";
import { SiteHeader } from "@/components/site-header";
import { requireProfile } from "@/lib/auth";
import { highlightCode } from "@/lib/highlight";
import { resolveNextQuestion } from "@/lib/questions/next-question";
import type { Language } from "@/lib/types/database";

export default async function PracticePage({
  searchParams,
}: {
  searchParams: Promise<{ question_id?: string }>;
}) {
  const { supabase, profile, user } = await requireProfile();
  const params = await searchParams;

  if (!profile.onboarding_completed) {
    redirect("/setup");
  }

  const languages: Language[] =
    profile.preferred_languages?.length > 0
      ? profile.preferred_languages
      : ["javascript", "java", "aem"];

  const preferredTopics = profile.preferred_topics?.filter(Boolean) ?? [];

  const { data: attempts } = await supabase
    .from("question_attempts")
    .select("question_id")
    .eq("user_id", user.id);

  const answeredIds = new Set((attempts ?? []).map((a) => a.question_id));

  const resolved = await resolveNextQuestion(supabase, {
    userId: user.id,
    languages,
    preferredTopics,
    answeredIds,
    questionId: params.question_id ?? null,
  });

  let html = "";
  if (resolved) {
    html = await highlightCode(
      resolved.question.snippet_code,
      resolved.question.snippet_language || resolved.question.language,
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
            initialQuestion={resolved?.question ?? null}
            initialHtml={html}
            initialLiked={resolved?.meta.liked ?? false}
            initialShare={resolved?.meta.share ?? null}
            initialQuestionId={params.question_id ?? null}
          />
        </div>
      </main>
    </div>
  );
}
