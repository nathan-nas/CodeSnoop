"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

/**
 * Handles magic-link / OTP redirects that land with hash tokens
 * (#access_token=...) which server routes cannot read.
 */
export default function AuthConfirmPage() {
  const router = useRouter();
  const [message, setMessage] = useState("Confirming your sign-in…");

  useEffect(() => {
    const run = async () => {
      const supabase = createClient();
      const hash = window.location.hash.replace(/^#/, "");
      const params = new URLSearchParams(hash);
      const accessToken = params.get("access_token");
      const refreshToken = params.get("refresh_token");

      if (accessToken && refreshToken) {
        const { error } = await supabase.auth.setSession({
          access_token: accessToken,
          refresh_token: refreshToken,
        });
        if (error) {
          setMessage(error.message);
          router.replace(`/login?error=${encodeURIComponent(error.message)}`);
          return;
        }
      } else {
        const {
          data: { session },
        } = await supabase.auth.getSession();
        if (!session) {
          router.replace("/login?error=auth");
          return;
        }
      }

      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        router.replace("/login?error=auth");
        return;
      }

      const { data: profile } = await supabase
        .from("profiles")
        .select("onboarding_completed")
        .eq("id", user.id)
        .single();

      router.replace(profile?.onboarding_completed ? "/dashboard" : "/setup");
    };

    void run();
  }, [router]);

  return (
    <main className="flex min-h-screen items-center justify-center px-6">
      <p className="text-[var(--ink-muted)]">{message}</p>
    </main>
  );
}
