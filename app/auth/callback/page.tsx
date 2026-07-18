"use client";

import { Suspense, useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

function CallbackInner() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [message, setMessage] = useState("Completing sign-in…");

  useEffect(() => {
    const run = async () => {
      const error =
        searchParams.get("error_description") ||
        searchParams.get("error") ||
        new URLSearchParams(window.location.hash.replace(/^#/, "")).get(
          "error_description",
        ) ||
        new URLSearchParams(window.location.hash.replace(/^#/, "")).get(
          "error",
        );

      if (error) {
        const decoded = decodeURIComponent(error.replace(/\+/g, " "));
        const friendly =
          decoded.includes("expired") || decoded.includes("invalid")
            ? "That email link was already used or expired (mail apps often open links before you do). Request a new code below."
            : decoded;
        router.replace(`/login?error=${encodeURIComponent(friendly)}&mode=magic`);
        return;
      }

      const supabase = createClient();
      const code = searchParams.get("code");
      const tokenHash = searchParams.get("token_hash");
      const type = searchParams.get("type");

      if (code) {
        const { error: exchangeError } =
          await supabase.auth.exchangeCodeForSession(code);
        if (exchangeError) {
          const msg =
            exchangeError.message.includes("code verifier") ||
            exchangeError.message.includes("PKCE")
              ? "Open the link in the same browser where you requested it, or use the 6-digit email code instead."
              : exchangeError.message;
          router.replace(`/login?error=${encodeURIComponent(msg)}&mode=magic`);
          return;
        }
      } else if (tokenHash && type) {
        const { error: otpError } = await supabase.auth.verifyOtp({
          type: type as "magiclink" | "email",
          token_hash: tokenHash,
        });
        if (otpError) {
          router.replace(
            `/login?error=${encodeURIComponent(otpError.message)}&mode=magic`,
          );
          return;
        }
      } else {
        // Hash-token fallback (implicit flow)
        const hash = window.location.hash.replace(/^#/, "");
        const params = new URLSearchParams(hash);
        const accessToken = params.get("access_token");
        const refreshToken = params.get("refresh_token");
        if (accessToken && refreshToken) {
          const { error: sessionError } = await supabase.auth.setSession({
            access_token: accessToken,
            refresh_token: refreshToken,
          });
          if (sessionError) {
            router.replace(
              `/login?error=${encodeURIComponent(sessionError.message)}&mode=magic`,
            );
            return;
          }
        } else {
          router.replace("/login?error=auth&mode=magic");
          return;
        }
      }

      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        router.replace("/login?error=auth&mode=magic");
        return;
      }

      const { data: profile } = await supabase
        .from("profiles")
        .select("onboarding_completed")
        .eq("id", user.id)
        .single();

      setMessage("Signed in. Redirecting…");
      router.replace(profile?.onboarding_completed ? "/dashboard" : "/setup");
    };

    void run();
  }, [router, searchParams]);

  return (
    <main className="flex min-h-screen items-center justify-center px-6">
      <p className="text-[var(--ink-muted)]">{message}</p>
    </main>
  );
}

export default function AuthCallbackPage() {
  return (
    <Suspense
      fallback={
        <main className="flex min-h-screen items-center justify-center px-6">
          <p className="text-[var(--ink-muted)]">Completing sign-in…</p>
        </main>
      }
    >
      <CallbackInner />
    </Suspense>
  );
}
