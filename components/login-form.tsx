"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useMemo, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { safeNextPath } from "@/lib/safe-next";

type Mode = "password" | "magic";

export function LoginForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const initialMode = (searchParams.get("mode") as Mode | null) ?? "password";
  const nextPath = safeNextPath(searchParams.get("next"));

  const [mode, setMode] = useState<Mode>(
    initialMode === "magic" ? "magic" : "password",
  );
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [otp, setOtp] = useState("");
  const [otpSent, setOtpSent] = useState(false);
  const [status, setStatus] = useState<"idle" | "loading" | "error">("idle");
  const urlError = useMemo(() => {
    const raw = searchParams.get("error");
    if (!raw) return null;
    if (raw === "auth") {
      return "Sign-in failed. Request a new email code and try again.";
    }
    return raw;
  }, [searchParams]);
  const [error, setError] = useState<string | null>(urlError);

  async function afterSignedIn() {
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      setError("Could not load your session.");
      setStatus("error");
      return;
    }

    const { data: profile } = await supabase
      .from("profiles")
      .select("onboarding_completed")
      .eq("id", user.id)
      .single();

    if (!profile?.onboarding_completed) {
      router.push("/setup");
    } else {
      router.push(nextPath ?? "/dashboard");
    }
    router.refresh();
  }

  function callbackUrl() {
    const base = `${window.location.origin}/auth/callback`;
    if (!nextPath) return base;
    return `${base}?next=${encodeURIComponent(nextPath)}`;
  }

  async function signInWithGitHub() {
    setStatus("loading");
    setError(null);
    const supabase = createClient();
    const { error: authError } = await supabase.auth.signInWithOAuth({
      provider: "github",
      options: {
        redirectTo: callbackUrl(),
      },
    });
    if (authError) {
      setError(authError.message);
      setStatus("error");
    }
  }

  async function signInWithPassword(e: React.FormEvent) {
    e.preventDefault();
    setStatus("loading");
    setError(null);
    const supabase = createClient();
    const { error: authError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (authError) {
      setError(authError.message);
      setStatus("error");
      return;
    }
    await afterSignedIn();
  }

  async function sendEmailCode(e: React.FormEvent) {
    e.preventDefault();
    setStatus("loading");
    setError(null);
    const supabase = createClient();
    const { error: authError } = await supabase.auth.signInWithOtp({
      email,
      options: {
        shouldCreateUser: true,
        // Keep redirect for the email link, but we primarily use the 6-digit code
        // because mail scanners often consume one-time verify links.
        emailRedirectTo: callbackUrl(),
      },
    });
    if (authError) {
      setError(authError.message);
      setStatus("error");
      return;
    }
    setOtpSent(true);
    setStatus("idle");
  }

  async function verifyEmailCode(e: React.FormEvent) {
    e.preventDefault();
    setStatus("loading");
    setError(null);
    const supabase = createClient();
    const { error: authError } = await supabase.auth.verifyOtp({
      email,
      token: otp.trim(),
      type: "email",
    });
    if (authError) {
      setError(authError.message);
      setStatus("error");
      return;
    }
    await afterSignedIn();
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

      <div className="flex rounded-md border border-[var(--line)] p-1 text-sm">
        <button
          type="button"
          onClick={() => setMode("password")}
          className={`flex-1 rounded px-3 py-1.5 font-medium ${
            mode === "password"
              ? "bg-[var(--ink)] text-white"
              : "text-[var(--ink-muted)]"
          }`}
        >
          Password
        </button>
        <button
          type="button"
          onClick={() => setMode("magic")}
          className={`flex-1 rounded px-3 py-1.5 font-medium ${
            mode === "magic"
              ? "bg-[var(--ink)] text-white"
              : "text-[var(--ink-muted)]"
          }`}
        >
          Email code
        </button>
      </div>

      {mode === "password" ? (
        <form onSubmit={signInWithPassword} className="space-y-3">
          <label className="block text-sm text-[var(--ink-muted)]">
            Email
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
              placeholder="you@example.com"
              autoComplete="email"
            />
          </label>
          <label className="block text-sm text-[var(--ink-muted)]">
            Password
            <input
              type="password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
              autoComplete="current-password"
            />
          </label>
          <button
            type="submit"
            disabled={status === "loading"}
            className="w-full rounded-md bg-[var(--accent)] px-4 py-3 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] disabled:opacity-60"
          >
            Sign in
          </button>
        </form>
      ) : !otpSent ? (
        <form onSubmit={sendEmailCode} className="space-y-3">
          <label className="block text-sm text-[var(--ink-muted)]">
            Email
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
              placeholder="you@example.com"
              autoComplete="email"
            />
          </label>
          <button
            type="submit"
            disabled={status === "loading"}
            className="w-full rounded-md bg-[var(--accent)] px-4 py-3 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] disabled:opacity-60"
          >
            Send login code
          </button>
          <p className="text-xs text-[var(--ink-muted)]">
            We’ll email a 6-digit code. Prefer the code over the link — mail
            apps often invalidate one-click links before you open them.
          </p>
        </form>
      ) : (
        <form onSubmit={verifyEmailCode} className="space-y-3">
          <p className="text-sm text-[var(--ok)]">
            Code sent to <span className="font-medium">{email}</span>
          </p>
          <label className="block text-sm text-[var(--ink-muted)]">
            6-digit code
            <input
              type="text"
              inputMode="numeric"
              pattern="[0-9]*"
              required
              value={otp}
              onChange={(e) => setOtp(e.target.value)}
              className="mt-1 w-full rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 font-mono text-lg tracking-widest text-[var(--ink)] outline-none ring-[var(--accent)] focus:ring-2"
              placeholder="123456"
              autoComplete="one-time-code"
            />
          </label>
          <button
            type="submit"
            disabled={status === "loading"}
            className="w-full rounded-md bg-[var(--accent)] px-4 py-3 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)] disabled:opacity-60"
          >
            Verify and continue
          </button>
          <button
            type="button"
            className="w-full text-sm text-[var(--ink-muted)] hover:text-[var(--ink)]"
            onClick={() => {
              setOtpSent(false);
              setOtp("");
              setError(null);
            }}
          >
            Use a different email
          </button>
        </form>
      )}

      {error && <p className="text-sm text-[var(--danger)]">{error}</p>}
    </div>
  );
}
