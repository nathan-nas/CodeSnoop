import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json().catch(() => ({}));
  const questionId =
    typeof body.question_id === "string" ? body.question_id : "";
  const friendIds = Array.isArray(body.friend_ids)
    ? body.friend_ids.filter((id: unknown): id is string => typeof id === "string")
    : [];

  if (!questionId) {
    return NextResponse.json({ error: "question_id is required" }, { status: 400 });
  }

  if (friendIds.length === 0) {
    return NextResponse.json(
      { error: "Select at least one friend." },
      { status: 400 },
    );
  }

  const { data: question } = await supabase
    .from("questions")
    .select("id")
    .eq("id", questionId)
    .eq("status", "published")
    .maybeSingle();

  if (!question) {
    return NextResponse.json({ error: "Question not found" }, { status: 404 });
  }

  const uniqueFriendIds = [...new Set(friendIds)].filter((id) => id !== user.id);
  if (uniqueFriendIds.length === 0) {
    return NextResponse.json(
      { error: "Select at least one friend." },
      { status: 400 },
    );
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("display_name")
    .eq("id", user.id)
    .single();

  const senderName = profile?.display_name ?? "A friend";

  const rows = uniqueFriendIds.map((recipientId) => ({
    sender_id: user.id,
    recipient_id: recipientId,
    question_id: questionId,
    sender_display_name: senderName,
  }));

  let sharedCount = 0;
  for (const row of rows) {
    const { data, error } = await supabase
      .from("question_shares")
      .insert(row)
      .select("id")
      .maybeSingle();

    if (error) {
      if (error.code === "23505") continue;
      if (error.code === "42501") {
        return NextResponse.json(
          { error: "You can only share with friends." },
          { status: 403 },
        );
      }
      return NextResponse.json({ error: error.message }, { status: 500 });
    }

    if (data) sharedCount += 1;
  }

  return NextResponse.json({
    shared_count: sharedCount,
  });
}
