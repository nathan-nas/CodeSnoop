import Link from "next/link";
import { redirect } from "next/navigation";
import { FriendsPanel } from "@/components/friends-panel";
import { ProfileForm } from "@/components/profile-form";
import { SiteHeader } from "@/components/site-header";
import { SignOutButton } from "@/components/sign-out-button";
import { requireProfile } from "@/lib/auth";

export default async function ProfilePage({
  searchParams,
}: {
  searchParams: Promise<{ friends?: string; invite_error?: string }>;
}) {
  const { profile, user } = await requireProfile();

  if (!profile.onboarding_completed) {
    redirect("/setup");
  }

  const params = await searchParams;
  const highlightFriends = params.friends === "1" || Boolean(params.invite_error);

  return (
    <div className="relative min-h-screen">
      <div className="pointer-events-none absolute inset-0 grid-noise opacity-40" />
      <SiteHeader
        right={
          <div className="flex items-center gap-3">
            <Link
              href="/dashboard"
              className="text-sm text-[var(--ink-muted)] hover:text-[var(--ink)]"
            >
              Dashboard
            </Link>
            <SignOutButton />
          </div>
        }
      />

      <main className="relative z-10 mx-auto max-w-2xl px-6 pb-20 md:px-10">
        <h1 className="font-[family-name:var(--font-display)] text-4xl tracking-tight md:text-5xl">
          Profile
        </h1>
        <p className="mt-2 text-[var(--ink-muted)]">
          Topics, languages, and friends — signed in as{" "}
          <span className="text-[var(--ink)]">{user.email}</span>
        </p>

        <div className="mt-10">
          <ProfileForm profile={profile} />
        </div>

        <div className="mt-14 border-t border-[var(--line)] pt-10">
          <FriendsPanel
            highlight={highlightFriends}
            initialError={params.invite_error ?? null}
          />
        </div>
      </main>
    </div>
  );
}
