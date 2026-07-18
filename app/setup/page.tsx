import { redirect } from "next/navigation";
import { SiteHeader } from "@/components/site-header";
import { AccountSetupForm } from "@/components/account-setup-form";
import { requireProfile } from "@/lib/auth";

export default async function SetupPage() {
  const { profile, user } = await requireProfile();

  if (profile.onboarding_completed) {
    redirect("/dashboard");
  }

  return (
    <div className="relative flex min-h-screen flex-col">
      <div className="pointer-events-none absolute inset-0 grid-noise opacity-40" />
      <SiteHeader />
      <main className="relative z-10 mx-auto flex w-full max-w-lg flex-1 flex-col justify-center px-6 pb-16">
        <h1 className="font-[family-name:var(--font-display)] text-4xl tracking-tight">
          Set up your account
        </h1>
        <p className="mt-2 text-[var(--ink-muted)]">
          Choose a display name and password so you can sign in again with
          email. Then pick what you want to practice.
        </p>
        <div className="mt-8 rounded-xl border border-[var(--line)] bg-[var(--surface)] p-6 backdrop-blur">
          <AccountSetupForm
            email={user.email ?? ""}
            initialDisplayName={profile.display_name ?? ""}
            initialLanguages={profile.preferred_languages ?? []}
          />
        </div>
      </main>
    </div>
  );
}
