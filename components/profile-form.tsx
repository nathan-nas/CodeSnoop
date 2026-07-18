"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { TOPIC_CATALOG } from "@/lib/topics";
import type { Language, Profile } from "@/lib/types/database";

const LANG_OPTIONS: { id: Language; label: string; hint: string }[] = [
  {
    id: "javascript",
    label: "JavaScript",
    hint: "async, closures, nullish quirks",
  },
  {
    id: "java",
    label: "Java",
    hint: "streams, equality, concurrency traps",
  },
  {
    id: "aem",
    label: "AEM",
    hint: "Sling, OSGi, HTL, Dispatcher, Oak",
  },
];

export function ProfileForm({ profile }: { profile: Profile }) {
  const router = useRouter();
  const [displayName, setDisplayName] = useState(profile.display_name ?? "");
  const [languages, setLanguages] = useState<Language[]>(
    profile.preferred_languages?.length
      ? profile.preferred_languages
      : ["javascript"],
  );
  const [topics, setTopics] = useState<string[]>(
    profile.preferred_topics ?? [],
  );
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState(false);
  const [loading, setLoading] = useState(false);

  function toggleLang(lang: Language) {
    setLanguages((prev) =>
      prev.includes(lang) ? prev.filter((l) => l !== lang) : [...prev, lang],
    );
    setSaved(false);
  }

  function toggleTopic(topic: string) {
    setTopics((prev) =>
      prev.includes(topic)
        ? prev.filter((t) => t !== topic)
        : prev.length >= 20
          ? prev
          : [...prev, topic],
    );
    setSaved(false);
  }

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setSaved(false);

    if (!displayName.trim()) {
      setError("Enter a display name.");
      return;
    }
    if (languages.length === 0) {
      setError("Pick at least one language.");
      return;
    }

    setLoading(true);
    const res = await fetch("/api/me", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        display_name: displayName.trim(),
        preferred_languages: languages,
        preferred_topics: topics,
      }),
    });

    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "Could not save.");
      setLoading(false);
      return;
    }

    setLoading(false);
    setSaved(true);
    router.refresh();
  }

  return (
    <form onSubmit={onSubmit} className="space-y-8">
      <section>
        <h2 className="font-[family-name:var(--font-display)] text-2xl">
          Account
        </h2>
        <p className="mt-1 text-sm text-[var(--ink-muted)]">
          How you show up on the friends leaderboard.
        </p>
        <label className="mt-4 block text-sm text-[var(--ink-muted)]">
          Display name
          <input
            type="text"
            required
            value={displayName}
            onChange={(e) => {
              setDisplayName(e.target.value);
              setSaved(false);
            }}
            className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
          />
        </label>

        <p className="mb-2 mt-5 text-sm text-[var(--ink-muted)]">Languages</p>
        <div className="space-y-3">
          {LANG_OPTIONS.map((opt) => {
            const active = languages.includes(opt.id);
            return (
              <button
                key={opt.id}
                type="button"
                onClick={() => toggleLang(opt.id)}
                className={`w-full rounded-lg border px-4 py-3 text-left transition ${
                  active
                    ? "border-[var(--accent)] bg-[rgba(15,110,86,0.08)]"
                    : "border-[var(--line)] bg-white/50 hover:border-[var(--ink-muted)]"
                }`}
              >
                <span className="block font-semibold">{opt.label}</span>
                <span className="text-sm text-[var(--ink-muted)]">
                  {opt.hint}
                </span>
              </button>
            );
          })}
        </div>
      </section>

      <section>
        <h2 className="font-[family-name:var(--font-display)] text-2xl">
          Topics
        </h2>
        <p className="mt-1 text-sm text-[var(--ink-muted)]">
          Practice prefers questions tagged with these topics. Leave empty for
          everything.
        </p>
        <div className="mt-4 flex flex-wrap gap-2">
          {TOPIC_CATALOG.map((topic) => {
            const active = topics.includes(topic);
            return (
              <button
                key={topic}
                type="button"
                onClick={() => toggleTopic(topic)}
                className={`rounded-md border px-3 py-1.5 text-sm transition ${
                  active
                    ? "border-[var(--accent)] bg-[rgba(15,110,86,0.12)] font-medium text-[var(--accent-strong)]"
                    : "border-[var(--line)] bg-white/50 text-[var(--ink-muted)] hover:border-[var(--ink-muted)]"
                }`}
              >
                {topic}
              </button>
            );
          })}
        </div>
      </section>

      {error && <p className="text-sm text-[var(--danger)]">{error}</p>}
      {saved && (
        <p className="text-sm text-[var(--ok)]">Profile saved.</p>
      )}

      <button
        type="submit"
        disabled={loading}
        className="rounded-md bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-white hover:bg-[var(--accent-strong)] disabled:opacity-60"
      >
        {loading ? "Saving…" : "Save preferences"}
      </button>
    </form>
  );
}
