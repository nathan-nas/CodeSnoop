import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import type { FriendLeaderboardRow } from "@/lib/types/database";

export async function GET() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { data: profile, error: profileError } = await supabase
    .from("profiles")
    .select("friend_code")
    .eq("id", user.id)
    .single();

  if (profileError || !profile) {
    return NextResponse.json(
      { error: profileError?.message ?? "Profile not found" },
      { status: 500 },
    );
  }

  const { data: leaderboard, error: lbError } = await supabase.rpc(
    "get_friends_leaderboard",
  );

  if (lbError) {
    return NextResponse.json({ error: lbError.message }, { status: 500 });
  }

  return NextResponse.json({
    friend_code: profile.friend_code as string,
    invite_path: `/invite/${profile.friend_code}`,
    leaderboard: (leaderboard ?? []) as FriendLeaderboardRow[],
  });
}

export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json().catch(() => ({}));
  const code = typeof body.code === "string" ? body.code.trim() : "";
  if (!code || code.length > 32) {
    return NextResponse.json({ error: "Enter a friend code." }, { status: 400 });
  }

  const { data, error } = await supabase.rpc("redeem_friend_code", {
    p_code: code,
  });

  if (error) {
    const msg = error.message.toLowerCase();
    if (msg.includes("invalid friend code")) {
      return NextResponse.json({ error: "Invalid friend code." }, { status: 404 });
    }
    if (msg.includes("cannot add yourself")) {
      return NextResponse.json(
        { error: "You can’t add yourself." },
        { status: 400 },
      );
    }
    return NextResponse.json({ error: error.message }, { status: 400 });
  }

  const row = Array.isArray(data) ? data[0] : data;
  return NextResponse.json({
    friend: row
      ? { id: row.friend_id, display_name: row.display_name }
      : null,
  });
}

export async function DELETE(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json().catch(() => ({}));
  const friendId = typeof body.friend_id === "string" ? body.friend_id : "";
  if (!friendId) {
    return NextResponse.json({ error: "Missing friend_id" }, { status: 400 });
  }

  const a = user.id < friendId ? user.id : friendId;
  const b = user.id < friendId ? friendId : user.id;

  const { error } = await supabase
    .from("friendships")
    .delete()
    .eq("user_id", a)
    .eq("friend_id", b);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ ok: true });
}
