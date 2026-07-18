"use client";

import { useState } from "react";
import { createClient } from "@/lib/supabase/client";

export function LoginForm() {
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState<"idle" | "loading" | "sent" | "error">(
    "idle",
  );
  const [error, setError] = useState<string | null>(null);

  async function signInWithGitHub() {
    setStatus("loading");
    setError(null);
    const supabase = createClient();
    const { error: authError } = await supabase.auth.signInWithOAuth({
      provider: "github",
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
      },
    });
    if (authError) {
      setError(authError.message);
      setStatus("error");
    }
  }

  async function signInWithMagicLink(e: React.FormEvent) {
    e.preventDefault();
    setStatus("loading");
    setError(null);
    const supabase = createClient();
    const { error: authError } = await supabase.auth.signInWithOtp({
      email,
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback`,
      },
    });
    if (authError) {
      setError(authError.message);
      setStatus("error");
      return;
    }
    setStatus("sent");
  }

  return (
    <div className="space-y-6">
      <button
        type="button"
        onClick={signInWithGitHub}
        disabled={status === "loading"}
        className="flex w-full items-center justify-center gap-2 rounded-md bg-[var(--ink)] px-4 py-3 text-sm font-semibold text-white transition hover:opacity-90 disabled:opacity-60"
      >
        Continue with GitHub
      </button>

      <div className="flex items-center gap-3 text-xs uppercase tracking-wide text-[var(--ink-muted)]">
        <span className="h-px flex-1 bg-[var(--line)]" />
        or email
        <span className="h-px flex-1 bg-[var(--line)]" />
      </div>

      <form onSubmit={signInWithMagicLink} className="space-y-3">
        <label className="block text-sm text-[var(--ink-muted)]">
          Email
          <input
            type="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
            placeholder="you@example.com"
          />
        </label>
        <button
          type="submit"
          disabled={status === "loading"}
          className="w-full rounded-md bg-[var(--accent)] px-4 py-3 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] disabled:opacity-60"
        >
          Send magic link
        </button>
      </form>

      {status === "sent" && (
        <p className="text-sm text-[var(--ok)]">
          Check your email for the sign-in link.
        </p>
      )}
      {error && <p className="text-sm text-[var(--danger)]">{error}</p>}
    </div>
  );
}
