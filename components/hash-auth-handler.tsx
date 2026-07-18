"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

/** Completes email magic-link sessions that arrive as URL hash tokens. */
export function HashAuthHandler() {
  const router = useRouter();

  useEffect(() => {
    const hash = window.location.hash;
    if (!hash) return;

    const params = new URLSearchParams(hash.replace(/^#/, ""));
    const hashError =
      params.get("error_description") || params.get("error");
    if (hashError) {
      const decoded = decodeURIComponent(hashError.replace(/\+/g, " "));
      window.history.replaceState(null, "", window.location.pathname);
      router.replace(
        `/login?error=${encodeURIComponent(decoded)}&mode=magic`,
      );
      return;
    }

    if (!hash.includes("access_token=")) return;

    const run = async () => {
      const accessToken = params.get("access_token");
      const refreshToken = params.get("refresh_token");
      if (!accessToken || !refreshToken) return;

      const supabase = createClient();
      const { error } = await supabase.auth.setSession({
        access_token: accessToken,
        refresh_token: refreshToken,
      });

      // Clear tokens from the address bar.
      window.history.replaceState(null, "", window.location.pathname);

      if (error) {
        router.replace(`/login?error=${encodeURIComponent(error.message)}`);
        return;
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

  return null;
}
