import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const DAILY_GOAL = 5;

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
    .select("*")
    .eq("id", user.id)
    .single();

  if (profileError) {
    return NextResponse.json({ error: profileError.message }, { status: 500 });
  }

  const startOfToday = new Date();
  startOfToday.setUTCHours(0, 0, 0, 0);

  const { count: todayCount } = await supabase
    .from("question_attempts")
    .select("*", { count: "exact", head: true })
    .eq("user_id", user.id)
    .gte("created_at", startOfToday.toISOString());

  const { data: stats } = await supabase
    .from("user_stats")
    .select("*")
    .eq("user_id", user.id)
    .order("accuracy", { ascending: true });

  const weak = (stats ?? []).filter((s) => s.questions_answered >= 2).slice(0, 3);
  const strong = [...(stats ?? [])]
    .filter((s) => s.questions_answered >= 2)
    .sort((a, b) => b.accuracy - a.accuracy)
    .slice(0, 3);

  const { count: totalAnswered } = await supabase
    .from("question_attempts")
    .select("*", { count: "exact", head: true })
    .eq("user_id", user.id);

  const { count: totalCorrect } = await supabase
    .from("question_attempts")
    .select("*", { count: "exact", head: true })
    .eq("user_id", user.id)
    .eq("is_correct", true);

  return NextResponse.json({
    profile,
    today: {
      answered: todayCount ?? 0,
      goal: DAILY_GOAL,
    },
    totals: {
      answered: totalAnswered ?? 0,
      correct: totalCorrect ?? 0,
    },
    weak_areas: weak.map((s) => ({
      topic: s.topic,
      language: s.language,
      accuracy: s.accuracy,
    })),
    strong_areas: strong.map((s) => ({
      topic: s.topic,
      language: s.language,
      accuracy: s.accuracy,
    })),
  });
}
