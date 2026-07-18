import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { sanitizePreferredTopics } from "@/lib/topics";
import type { Language } from "@/lib/types/database";

export async function GET() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { data: profile, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ profile });
}

export async function PATCH(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const updates: {
    preferred_languages?: Language[];
    preferred_topics?: string[];
    onboarding_completed?: boolean;
    display_name?: string;
  } = {};

  if (Array.isArray(body.preferred_languages)) {
    const langs = body.preferred_languages.filter(
      (l: unknown): l is Language =>
        l === "java" || l === "javascript" || l === "aem",
    );
    updates.preferred_languages = langs;
  }
  if ("preferred_topics" in body) {
    updates.preferred_topics = sanitizePreferredTopics(body.preferred_topics);
  }
  if (typeof body.onboarding_completed === "boolean") {
    updates.onboarding_completed = body.onboarding_completed;
  }
  if (typeof body.display_name === "string") {
    updates.display_name = body.display_name.trim().slice(0, 80);
  }

  if (Object.keys(updates).length === 0) {
    return NextResponse.json({ error: "No valid fields" }, { status: 400 });
  }

  const { data: profile, error } = await supabase
    .from("profiles")
    .update(updates)
    .eq("id", user.id)
    .select("*")
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ profile });
}
