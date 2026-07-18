import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
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
    onboarding_completed?: boolean;
    display_name?: string;
  } = {};

  if (Array.isArray(body.preferred_languages)) {
    updates.preferred_languages = body.preferred_languages;
  }
  if (typeof body.onboarding_completed === "boolean") {
    updates.onboarding_completed = body.onboarding_completed;
  }
  if (typeof body.display_name === "string") {
    updates.display_name = body.display_name;
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
