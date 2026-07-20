"use client";

import Link from "next/link";
import { useCallback, useEffect, useState } from "react";
import type { LikedQuestionRow } from "@/lib/types/database";

export function LikedQuestionsPanel() {
  const [questions, setQuestions] = useState<LikedQuestionRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [removingId, setRemovingId] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);

    const res = await fetch("/api/questions/like");
    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "Could not load liked questions.");
      setLoading(false);
      return;
    }

    const body = await res.json();
    setQuestions(body.questions ?? []);
    setLoading(false);
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  async function unlike(questionId: string) {
    setRemovingId(questionId);
    const res = await fetch("/api/questions/like", {
      method: "DELETE",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ question_id: questionId }),
    });
    setRemovingId(null);

    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "Could not remove like.");
      return;
    }

    setQuestions((prev) => prev.filter((q) => q.question_id !== questionId));
  }

  return (
    <section id="liked" className="scroll-mt-8">
      <h2 className="font-[family-name:var(--font-display)] text-2xl">
        Liked questions
      </h2>
      <p className="mt-1 text-sm text-[var(--ink-muted)]">
        Questions you saved to revisit and practice again.
      </p>

      {error && <p className="mt-3 text-sm text-[var(--danger)]">{error}</p>}

      <div className="mt-5 space-y-3">
        {loading ? (
          <p className="text-sm text-[var(--ink-muted)]">Loading…</p>
        ) : questions.length === 0 ? (
          <p className="rounded-xl border border-[var(--line)] bg-[var(--surface)] p-5 text-sm text-[var(--ink-muted)]">
            No liked questions yet. Tap the heart on any practice question to
            save it here.
          </p>
        ) : (
          questions.map((q) => (
            <div
              key={q.question_id}
              className="flex flex-wrap items-start justify-between gap-3 rounded-xl border border-[var(--line)] bg-[var(--surface)] p-4"
            >
              <div className="min-w-0 flex-1">
                <p className="font-medium leading-snug">{q.question_stem}</p>
                <p className="mt-1 text-xs uppercase tracking-wide text-[var(--ink-muted)]">
                  {q.language} · {q.difficulty}
                  {q.topic_tags?.slice(0, 2).map((tag) => ` · ${tag}`)}
                </p>
              </div>
              <div className="flex shrink-0 gap-2">
                <Link
                  href={`/practice?question_id=${q.question_id}`}
                  className="rounded-md bg-[var(--accent)] px-3 py-1.5 text-sm font-semibold text-white hover:bg-[var(--accent-strong)]"
                >
                  Practice
                </Link>
                <button
                  type="button"
                  disabled={removingId === q.question_id}
                  onClick={() => void unlike(q.question_id)}
                  className="rounded-md border border-[var(--line)] px-3 py-1.5 text-sm font-semibold text-[var(--ink-muted)] hover:text-[var(--danger)] disabled:opacity-50"
                >
                  {removingId === q.question_id ? "…" : "Unlike"}
                </button>
              </div>
            </div>
          ))
        )}
      </div>
    </section>
  );
}
