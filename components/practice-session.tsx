"use client";

import Link from "next/link";
import { useCallback, useEffect, useRef, useState } from "react";
import type { PublicQuestion, PublicQuestionMeta } from "@/lib/types/database";
import { CodeBlock } from "@/components/code-block";
import { ShareQuestionModal } from "@/components/share-question-modal";

type AnswerResult = {
  is_correct: boolean;
  correct_option_index: number;
  points_awarded: number;
  explanation: string;
  thought_process: string;
};

type PrefetchedNext = {
  topicKey: string;
  question: PublicQuestion;
  html: string;
  liked: boolean;
  share: PublicQuestionMeta["share"] | null;
};

function topicKey(topic?: string) {
  return topic ?? "__default__";
}

function QuestionLoading() {
  return (
    <div
      className="space-y-6"
      role="status"
      aria-live="polite"
      aria-busy="true"
    >
      <div className="flex items-center gap-3 text-sm text-[var(--ink-muted)]">
        <span className="practice-spinner" aria-hidden />
        <span>Loading next question…</span>
      </div>

      <div className="flex flex-wrap gap-2">
        <div className="practice-skel h-5 w-16" />
        <div className="practice-skel h-5 w-14" />
        <div className="practice-skel h-5 w-20" />
      </div>

      <div className="overflow-hidden rounded-xl border border-[var(--code-border)] bg-[var(--code-bg)] p-5">
        <div className="space-y-3">
          <div className="practice-skel h-3 w-[92%]" />
          <div className="practice-skel h-3 w-[78%]" />
          <div className="practice-skel h-3 w-[85%]" />
          <div className="practice-skel h-3 w-[60%]" />
          <div className="practice-skel h-3 w-[70%]" />
        </div>
      </div>

      <div className="space-y-3">
        <div className="practice-skel h-7 w-[70%]" />
        <div className="practice-skel h-12 w-full" />
        <div className="practice-skel h-12 w-full" />
        <div className="practice-skel h-12 w-full" />
        <div className="practice-skel h-12 w-full" />
      </div>
    </div>
  );
}

export function PracticeSession({
  initialQuestion,
  initialHtml,
  initialLiked = false,
  initialShare = null,
  initialQuestionId = null,
}: {
  initialQuestion: PublicQuestion | null;
  initialHtml: string;
  initialLiked?: boolean;
  initialShare?: PublicQuestionMeta["share"] | null;
  initialQuestionId?: string | null;
}) {
  const [question, setQuestion] = useState(initialQuestion);
  const [html, setHtml] = useState(initialHtml);
  const [liked, setLiked] = useState(initialLiked);
  const [share, setShare] = useState(initialShare);
  const [selected, setSelected] = useState<number | null>(null);
  const [result, setResult] = useState<AnswerResult | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [liking, setLiking] = useState(false);
  const [loadingNext, setLoadingNext] = useState(!initialQuestion);
  const [error, setError] = useState<string | null>(null);
  const [startedAt, setStartedAt] = useState(() => Date.now());
  const [shareOpen, setShareOpen] = useState(false);
  const prefetchedRef = useRef<PrefetchedNext | null>(null);
  const prefetchingRef = useRef<Promise<PrefetchedNext | null> | null>(null);
  const prefetchGenerationRef = useRef(0);

  const fetchQuestionWithHtml = useCallback(
    async (opts?: { topic?: string; excludeId?: string; questionId?: string }) => {
      const params = new URLSearchParams();
      if (opts?.topic) params.set("topic", opts.topic);
      if (opts?.excludeId) params.set("exclude", opts.excludeId);
      if (opts?.questionId) params.set("question_id", opts.questionId);

      const res = await fetch(`/api/questions/next?${params.toString()}`);
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error ?? "No questions available.");
      }

      const body = await res.json();
      const q = body.question as PublicQuestion;

      const htmlRes = await fetch("/api/highlight", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          code: q.snippet_code,
          language: q.snippet_language || q.language,
        }),
      });
      const htmlBody = await htmlRes.json();

      return {
        question: q,
        html: htmlBody.html ?? "",
        liked: Boolean(body.liked),
        share: (body.share as PublicQuestionMeta["share"] | null) ?? null,
      };
    },
    [],
  );

  const applyQuestion = useCallback(
    (
      q: PublicQuestion,
      highlightedHtml: string,
      meta?: { liked?: boolean; share?: PublicQuestionMeta["share"] | null },
    ) => {
      setResult(null);
      setSelected(null);
      setError(null);
      setQuestion(q);
      setHtml(highlightedHtml);
      setLiked(meta?.liked ?? false);
      setShare(meta?.share ?? null);
      setStartedAt(Date.now());
      setLoadingNext(false);
    },
    [],
  );

  const prefetchNext = useCallback(
    (topic?: string, excludeId?: string) => {
      const key = topicKey(topic);
      const generation = ++prefetchGenerationRef.current;
      const promise = (async () => {
        try {
          const data = await fetchQuestionWithHtml({ topic, excludeId });
          const prefetched: PrefetchedNext = {
            topicKey: key,
            question: data.question,
            html: data.html,
            liked: data.liked,
            share: data.share,
          };
          if (prefetchGenerationRef.current === generation) {
            prefetchedRef.current = prefetched;
          }
          return prefetched;
        } catch {
          return null;
        } finally {
          if (prefetchGenerationRef.current === generation) {
            prefetchingRef.current = null;
          }
        }
      })();
      prefetchingRef.current = promise;
    },
    [fetchQuestionWithHtml],
  );

  const loadNext = useCallback(
    async (topic?: string) => {
      const key = topicKey(topic);

      const cached = prefetchedRef.current;
      if (cached?.topicKey === key) {
        prefetchedRef.current = null;
        applyQuestion(cached.question, cached.html, {
          liked: cached.liked,
          share: cached.share,
        });
        prefetchNext(undefined, cached.question.id);
        return;
      }

      if (prefetchingRef.current) {
        const pending = await prefetchingRef.current;
        if (pending?.topicKey === key) {
          prefetchedRef.current = null;
          applyQuestion(pending.question, pending.html, {
            liked: pending.liked,
            share: pending.share,
          });
          prefetchNext(undefined, pending.question.id);
          return;
        }
      }

      setLoadingNext(true);
      setError(null);
      setResult(null);
      setSelected(null);
      setQuestion(null);
      setHtml("");
      setShare(null);

      try {
        const data = await fetchQuestionWithHtml({ topic });
        applyQuestion(data.question, data.html, {
          liked: data.liked,
          share: data.share,
        });
        prefetchNext(undefined, data.question.id);
      } catch (e) {
        setError(
          e instanceof Error ? e.message : "Could not load the next question.",
        );
        setQuestion(null);
        setLoadingNext(false);
      }
    },
    [applyQuestion, fetchQuestionWithHtml, prefetchNext],
  );

  useEffect(() => {
    if (initialQuestion) return;

    void (async () => {
      setLoadingNext(true);
      try {
        const data = await fetchQuestionWithHtml({
          questionId: initialQuestionId ?? undefined,
        });
        applyQuestion(data.question, data.html, {
          liked: data.liked,
          share: data.share,
        });
        prefetchNext(undefined, data.question.id);
      } catch (e) {
        setError(
          e instanceof Error ? e.message : "Could not load the next question.",
        );
        setLoadingNext(false);
      }
    })();
  }, [
    initialQuestion,
    initialQuestionId,
    fetchQuestionWithHtml,
    applyQuestion,
    prefetchNext,
  ]);

  useEffect(() => {
    if (!question || result) return;
    prefetchNext(undefined, question.id);
  }, [question?.id, result, prefetchNext]);

  async function toggleLike() {
    if (!question || liking) return;
    setLiking(true);
    setError(null);

    const method = liked ? "DELETE" : "POST";
    const res = await fetch("/api/questions/like", {
      method,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ question_id: question.id }),
    });

    setLiking(false);

    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "Could not update like.");
      return;
    }

    setLiked(!liked);
  }

  async function submit() {
    if (!question || selected === null) return;
    setSubmitting(true);
    setError(null);

    const res = await fetch("/api/questions/answer", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        question_id: question.id,
        selected_option_index: selected,
        time_taken_ms: Date.now() - startedAt,
      }),
    });

    const body = await res.json();
    if (!res.ok) {
      setError(body.error ?? "Could not submit answer.");
      setSubmitting(false);
      return;
    }

    setResult(body);
    setSubmitting(false);
    setShare(null);
    prefetchedRef.current = null;
    prefetchNext(undefined, question.id);
  }

  if (loadingNext) {
    return <QuestionLoading />;
  }

  if (!question) {
    return (
      <div className="rounded-xl border border-[var(--line)] bg-[var(--surface)] p-8 text-center">
        <p className="text-[var(--ink-muted)]">
          {error ?? "No published questions yet."}
        </p>
        <Link
          href="/dashboard"
          className="mt-4 inline-block text-sm font-semibold text-[var(--accent)]"
        >
          Back to dashboard
        </Link>
      </div>
    );
  }

  const options = question.options ?? [];

  return (
    <div className="space-y-6">
      {share && (
        <div className="rounded-lg border border-[var(--accent)] bg-[rgba(15,110,86,0.08)] px-4 py-3 text-sm">
          <p className="font-semibold text-[var(--accent)]">Friend challenge</p>
          <p className="mt-0.5 text-[var(--ink-muted)]">
            Shared by {share.sender_name ?? "a friend"}
          </p>
        </div>
      )}

      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="flex flex-wrap items-center gap-2 text-xs uppercase tracking-wide text-[var(--ink-muted)]">
          <span>{question.language}</span>
          <span>·</span>
          <span>{question.difficulty}</span>
          {question.topic_tags?.slice(0, 3).map((t) => (
            <span
              key={t}
              className="rounded border border-[var(--line)] px-2 py-0.5 normal-case tracking-normal"
            >
              {t}
            </span>
          ))}
        </div>

        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={() => void toggleLike()}
            disabled={liking}
            aria-pressed={liked}
            aria-label={liked ? "Unlike question" : "Like question"}
            className={`rounded-md border px-3 py-1.5 text-sm font-semibold transition ${
              liked
                ? "border-[var(--danger)] text-[var(--danger)]"
                : "border-[var(--line)] text-[var(--ink-muted)] hover:border-[var(--ink-muted)]"
            }`}
          >
            {liked ? "♥ Liked" : "♡ Like"}
          </button>
          <button
            type="button"
            onClick={() => setShareOpen(true)}
            className="rounded-md border border-[var(--line)] px-3 py-1.5 text-sm font-semibold text-[var(--ink-muted)] hover:border-[var(--ink-muted)]"
          >
            Share
          </button>
        </div>
      </div>

      <CodeBlock html={html} />

      <div>
        <h2 className="font-[family-name:var(--font-display)] text-2xl">
          {question.question_stem}
        </h2>
        <div className="mt-4 space-y-2">
          {options.map((opt, idx) => {
            const isSelected = selected === idx;
            const showResult = !!result;
            const isCorrect = result?.correct_option_index === idx;
            const isWrongPick =
              showResult && isSelected && !result.is_correct;

            let classes =
              "w-full rounded-lg border px-4 py-3 text-left text-sm transition ";
            if (showResult && isCorrect) {
              classes += "border-[var(--ok)] bg-[rgba(15,110,86,0.1)]";
            } else if (isWrongPick) {
              classes += "border-[var(--danger)] bg-[rgba(155,44,44,0.08)]";
            } else if (isSelected) {
              classes += "border-[var(--accent)] bg-[rgba(15,110,86,0.06)]";
            } else {
              classes +=
                "border-[var(--line)] bg-[var(--surface)] hover:border-[var(--ink-muted)]";
            }

            return (
              <button
                key={idx}
                type="button"
                disabled={!!result || submitting}
                onClick={() => setSelected(idx)}
                className={classes}
              >
                <span className="mr-2 font-mono text-[var(--ink-muted)]">
                  {String.fromCharCode(65 + idx)}.
                </span>
                {opt.text}
              </button>
            );
          })}
        </div>
      </div>

      {error && <p className="text-sm text-[var(--danger)]">{error}</p>}

      {!result ? (
        <button
          type="button"
          disabled={selected === null || submitting}
          onClick={submit}
          className="rounded-md bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-white hover:bg-[var(--accent-strong)] disabled:opacity-50"
        >
          {submitting ? "Submitting…" : "Submit answer"}
        </button>
      ) : (
        <div className="space-y-5 rounded-xl border border-[var(--line)] bg-[var(--surface)] p-6">
          <p
            className={`font-[family-name:var(--font-display)] text-2xl ${
              result.is_correct ? "text-[var(--ok)]" : "text-[var(--danger)]"
            }`}
          >
            {result.is_correct
              ? `Correct · +${result.points_awarded} pts`
              : "Not quite"}
          </p>
          <section>
            <h3 className="text-sm font-semibold uppercase tracking-wide text-[var(--ink-muted)]">
              Explanation
            </h3>
            <p className="mt-2 leading-relaxed">{result.explanation}</p>
          </section>
          <section>
            <h3 className="text-sm font-semibold uppercase tracking-wide text-[var(--ink-muted)]">
              Thought process
            </h3>
            <p className="mt-2 whitespace-pre-wrap leading-relaxed">
              {result.thought_process}
            </p>
          </section>
          <div className="flex flex-wrap gap-3 pt-2">
            <button
              type="button"
              onClick={() => void loadNext()}
              className="rounded-md bg-[var(--accent)] px-4 py-2 text-sm font-semibold text-white hover:bg-[var(--accent-strong)]"
            >
              Next question
            </button>
            <button
              type="button"
              onClick={() => void loadNext(question.topic_tags?.[0])}
              className="rounded-md border border-[var(--line)] px-4 py-2 text-sm font-semibold"
            >
              More like this
            </button>
            <Link
              href="/dashboard"
              className="rounded-md px-4 py-2 text-sm font-semibold text-[var(--ink-muted)]"
            >
              Dashboard
            </Link>
          </div>
        </div>
      )}

      <ShareQuestionModal
        questionId={question.id}
        open={shareOpen}
        onClose={() => setShareOpen(false)}
      />
    </div>
  );
}
