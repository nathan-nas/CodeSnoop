import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

export default async function InvitePage({
  params,
}: {
  params: Promise<{ code: string }>;
}) {
  const { code: raw } = await params;
  const code = decodeURIComponent(raw).trim().toUpperCase();

  if (!code || code.length > 32) {
    redirect("/login");
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect(`/login?next=${encodeURIComponent(`/invite/${code}`)}`);
  }

  const { error } = await supabase.rpc("redeem_friend_code", {
    p_code: code,
  });

  if (error) {
    const msg = error.message.toLowerCase();
    if (msg.includes("cannot add yourself")) {
      redirect("/profile?friends=1");
    }
    redirect(
      `/profile?friends=1&invite_error=${encodeURIComponent(
        msg.includes("invalid") ? "Invalid invite code." : error.message,
      )}`,
    );
  }

  redirect("/profile?friends=1");
}
