"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import { createClient } from "@/lib/supabase/client";
import type { Language } from "@/lib/types/database";

const OPTIONS: { id: Language; label: string; hint: string }[] = [
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

export function AccountSetupForm({
  email,
  initialDisplayName,
  initialLanguages,
}: {
  email: string;
  initialDisplayName: string;
  initialLanguages: Language[];
}) {
  const router = useRouter();
  const [displayName, setDisplayName] = useState(initialDisplayName);
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
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
    setError(null);

    if (!displayName.trim()) {
      setError("Enter a display name.");
      return;
    }
    if (password.length < 8) {
      setError("Password must be at least 8 characters.");
      return;
    }
    if (password !== confirmPassword) {
      setError("Passwords do not match.");
      return;
    }
    if (selected.length === 0) {
      setError("Pick at least one language.");
      return;
    }

    setLoading(true);
    const supabase = createClient();

    const { error: authError } = await supabase.auth.updateUser({
      password,
      data: { full_name: displayName.trim() },
    });

    // Same password is fine when the user already signed in with one.
    if (
      authError &&
      !authError.message.toLowerCase().includes("different from the old password")
    ) {
      setError(authError.message);
      setLoading(false);
      return;
    }

    const res = await fetch("/api/me", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        display_name: displayName.trim(),
        preferred_languages: selected,
        onboarding_completed: true,
      }),
    });

    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "Could not save your profile.");
      setLoading(false);
      return;
    }

    router.push("/dashboard");
    router.refresh();
  }

  return (
    <form onSubmit={onSubmit} className="space-y-5">
      <p className="text-sm text-[var(--ink-muted)]">
        Signed in as <span className="font-medium text-[var(--ink)]">{email}</span>
      </p>

      <label className="block text-sm text-[var(--ink-muted)]">
        Display name
        <input
          type="text"
          required
          value={displayName}
          onChange={(e) => setDisplayName(e.target.value)}
          className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
          placeholder="Ada"
        />
      </label>

      <label className="block text-sm text-[var(--ink-muted)]">
        Password
        <input
          type="password"
          required
          minLength={8}
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
          placeholder="At least 8 characters"
          autoComplete="new-password"
        />
      </label>

      <label className="block text-sm text-[var(--ink-muted)]">
        Confirm password
        <input
          type="password"
          required
          minLength={8}
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
          autoComplete="new-password"
        />
      </label>

      <div>
        <p className="mb-2 text-sm text-[var(--ink-muted)]">Languages</p>
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
                <span className="text-sm text-[var(--ink-muted)]">
                  {opt.hint}
                </span>
              </button>
            );
          })}
        </div>
      </div>

      {error && <p className="text-sm text-[var(--danger)]">{error}</p>}

      <button
        type="submit"
        disabled={loading}
        className="w-full rounded-md bg-[var(--accent)] px-4 py-3 text-sm font-semibold text-white hover:bg-[var(--accent-strong)] disabled:opacity-60"
      >
        {loading ? "Saving…" : "Finish setup"}
      </button>
    </form>
  );
}
