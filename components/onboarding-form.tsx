"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import type { Language } from "@/lib/types/database";

const OPTIONS: { id: Language; label: string; hint: string }[] = [
  { id: "javascript", label: "JavaScript", hint: "async, closures, nullish quirks" },
  { id: "java", label: "Java", hint: "streams, equality, concurrency traps" },
  { id: "aem", label: "AEM", hint: "Sling, OSGi, HTL, Dispatcher, Oak" },
];

export function OnboardingForm({
  initialLanguages,
}: {
  initialLanguages: Language[];
}) {
  const router = useRouter();
  const [selected, setSelected] = useState<Language[]>(initialLanguages);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  function toggle(lang: Language) {
    setSelected((prev) =>
      prev.includes(lang) ? prev.filter((l) => l !== lang) : [...prev, lang],
    );
  }

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (selected.length === 0) {
      setError("Pick at least one language.");
      return;
    }
    setLoading(true);
    setError(null);

    const res = await fetch("/api/me", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        preferred_languages: selected,
        onboarding_completed: true,
      }),
    });

    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "Could not save preferences.");
      setLoading(false);
      return;
    }

    router.push("/dashboard");
    router.refresh();
  }

  return (
    <form onSubmit={onSubmit} className="space-y-4">
      <div className="space-y-3">
        {OPTIONS.map((opt) => {
          const active = selected.includes(opt.id);
          return (
            <button
              key={opt.id}
              type="button"
              onClick={() => toggle(opt.id)}
              className={`w-full rounded-lg border px-4 py-3 text-left transition ${
                active
                  ? "border-[var(--accent)] bg-[rgba(15,110,86,0.08)]"
                  : "border-[var(--line)] bg-white/50 hover:border-[var(--ink-muted)]"
              }`}
            >
              <span className="block font-semibold">{opt.label}</span>
              <span className="text-sm text-[var(--ink-muted)]">{opt.hint}</span>
            </button>
          );
        })}
      </div>
      {error && <p className="text-sm text-[var(--danger)]">{error}</p>}
      <button
        type="submit"
        disabled={loading}
        className="w-full rounded-md bg-[var(--accent)] px-4 py-3 text-sm font-semibold text-white hover:bg-[var(--accent-strong)] disabled:opacity-60"
      >
        {loading ? "Saving…" : "Continue to dashboard"}
      </button>
    </form>
  );
}
