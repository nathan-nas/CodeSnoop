import Link from "next/link";
import { redirect } from "next/navigation";
import { SiteHeader } from "@/components/site-header";
import { SignOutButton } from "@/components/sign-out-button";
import { requireProfile } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";

const DAILY_GOAL = 5;

export default async function DashboardPage() {
  const { profile, user } = await requireProfile();

  if (!profile.onboarding_completed) {
    redirect("/onboarding");
  }

  const supabase = await createClient();
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
    .eq("user_id", user.id);

  const ranked = [...(stats ?? [])].filter((s) => s.questions_answered >= 1);
  const weak = [...ranked].sort((a, b) => a.accuracy - b.accuracy).slice(0, 3);
  const strong = [...ranked]
    .sort((a, b) => b.accuracy - a.accuracy)
    .slice(0, 3);

  const level = Math.floor(profile.total_points / 100) + 1;

  return (
    <div className="relative min-h-screen">
      <div className="pointer-events-none absolute inset-0 grid-noise opacity-40" />
      <SiteHeader
        right={
          <div className="flex items-center gap-3">
            <span className="hidden text-sm text-[var(--ink-muted)] sm:inline">
              {profile.display_name ?? user.email}
            </span>
            <SignOutButton />
          </div>
        }
      />

      <main className="relative z-10 mx-auto max-w-4xl px-6 pb-16 md:px-10">
        <h1 className="font-[family-name:var(--font-display)] text-4xl tracking-tight md:text-5xl">
          Dashboard
        </h1>
        <p className="mt-2 text-[var(--ink-muted)]">
          Keep the streak. Read weird code. Get sharper.
        </p>

        <div className="mt-8 grid gap-4 sm:grid-cols-3">
          <Stat
            label="Points"
            value={String(profile.total_points)}
            hint={`Level ${level}`}
          />
          <Stat
            label="Daily streak"
            value={`${profile.daily_streak}`}
            hint="days in a row"
          />
          <Stat
            label="Today"
            value={`${todayCount ?? 0}/${DAILY_GOAL}`}
            hint="questions done"
          />
        </div>

        <div className="mt-6 flex flex-wrap gap-3">
          <Link
            href="/practice"
            className="rounded-md bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-white hover:bg-[var(--accent-strong)]"
          >
            Continue Practice
          </Link>
          <Link
            href="/practice?mode=challenge"
            className="rounded-md border border-[var(--line)] bg-[var(--surface)] px-5 py-3 text-sm font-semibold text-[var(--ink-muted)]"
            title="Coming soon"
          >
            Start Challenge
          </Link>
        </div>

        <div className="mt-10 grid gap-6 md:grid-cols-2">
          <AreaList title="Weak areas" empty="Answer a few to find patterns." items={weak} />
          <AreaList title="Strong areas" empty="Keep practicing." items={strong} />
        </div>
      </main>
    </div>
  );
}

function Stat({
  label,
  value,
  hint,
}: {
  label: string;
  value: string;
  hint: string;
}) {
  return (
    <div className="rounded-xl border border-[var(--line)] bg-[var(--surface)] p-5 backdrop-blur">
      <p className="text-xs uppercase tracking-wide text-[var(--ink-muted)]">
        {label}
      </p>
      <p className="mt-1 font-[family-name:var(--font-display)] text-3xl">
        {value}
      </p>
      <p className="mt-1 text-sm text-[var(--ink-muted)]">{hint}</p>
    </div>
  );
}

function AreaList({
  title,
  empty,
  items,
}: {
  title: string;
  empty: string;
  items: { topic: string; language: string; accuracy: number }[];
}) {
  return (
    <div className="rounded-xl border border-[var(--line)] bg-[var(--surface)] p-5 backdrop-blur">
      <h2 className="font-[family-name:var(--font-display)] text-xl">{title}</h2>
      {items.length === 0 ? (
        <p className="mt-3 text-sm text-[var(--ink-muted)]">{empty}</p>
      ) : (
        <ul className="mt-3 space-y-2">
          {items.map((item) => (
            <li
              key={`${item.language}-${item.topic}`}
              className="flex justify-between text-sm"
            >
              <span>
                {item.language === "javascript" ? "JS" : "Java"} · {item.topic}
              </span>
              <span className="text-[var(--ink-muted)]">
                {Math.round(item.accuracy * 100)}%
              </span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
