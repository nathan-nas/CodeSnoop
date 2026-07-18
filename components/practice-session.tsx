"use client";

import Link from "next/link";
import { useCallback, useEffect, useState } from "react";
import type { PublicQuestion } from "@/lib/types/database";
import { CodeBlock } from "@/components/code-block";

type AnswerResult = {
  is_correct: boolean;
  correct_option_index: number;
  points_awarded: number;
  explanation: string;
  thought_process: string;
};

export function PracticeSession({
  initialQuestion,
  initialHtml,
}: {
  initialQuestion: PublicQuestion | null;
  initialHtml: string;
}) {
  const [question, setQuestion] = useState(initialQuestion);
  const [html, setHtml] = useState(initialHtml);
  const [selected, setSelected] = useState<number | null>(null);
  const [result, setResult] = useState<AnswerResult | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [startedAt, setStartedAt] = useState(() => Date.now());

  const loadNext = useCallback(async (topic?: string) => {
    setLoading(true);
    setError(null);
    setResult(null);
    setSelected(null);

    const params = new URLSearchParams();
    if (topic) params.set("topic", topic);
    const res = await fetch(`/api/questions/next?${params.toString()}`);
    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "No questions available.");
      setQuestion(null);
      setLoading(false);
      return;
    }

    const body = await res.json();
    const q = body.question as PublicQuestion;
    setQuestion(q);

    const htmlRes = await fetch("/api/highlight", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        code: q.snippet_code,
        language: q.snippet_language || q.language,
      }),
    });
    const htmlBody = await htmlRes.json();
    setHtml(htmlBody.html ?? "");
    setStartedAt(Date.now());
    setLoading(false);
  }, []);

  useEffect(() => {
    if (!initialQuestion) {
      void loadNext();
    }
  }, [initialQuestion, loadNext]);

  async function submit() {
    if (!question || selected === null) return;
    setLoading(true);
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
      setLoading(false);
      return;
    }

    setResult(body);
    setLoading(false);
  }

  if (!question && !loading) {
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

  if (!question) {
    return (
      <p className="text-[var(--ink-muted)]">Loading next question…</p>
    );
  }

  const options = question.options ?? [];

  return (
    <div className="space-y-6">
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
                disabled={!!result || loading}
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
          disabled={selected === null || loading}
          onClick={submit}
          className="rounded-md bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-white hover:bg-[var(--accent-strong)] disabled:opacity-50"
        >
          {loading ? "Submitting…" : "Submit answer"}
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
              onClick={() => loadNext()}
              className="rounded-md bg-[var(--accent)] px-4 py-2 text-sm font-semibold text-white hover:bg-[var(--accent-strong)]"
            >
              Next question
            </button>
            <button
              type="button"
              onClick={() => loadNext(question.topic_tags?.[0])}
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
    </div>
  );
}
