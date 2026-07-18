import { redirect } from "next/navigation";
import { SiteHeader } from "@/components/site-header";
import { OnboardingForm } from "@/components/onboarding-form";
import { requireProfile } from "@/lib/auth";

export default async function OnboardingPage() {
  const { profile } = await requireProfile();

  if (profile.onboarding_completed) {
    redirect("/dashboard");
  }

  return (
    <div className="relative flex min-h-screen flex-col">
      <div className="pointer-events-none absolute inset-0 grid-noise opacity-40" />
      <SiteHeader />
      <main className="relative z-10 mx-auto flex w-full max-w-lg flex-1 flex-col justify-center px-6 pb-16">
        <h1 className="font-[family-name:var(--font-display)] text-4xl tracking-tight">
          What do you want to practice?
        </h1>
        <p className="mt-2 text-[var(--ink-muted)]">
          Pick one or both. You can change this later.
        </p>
        <div className="mt-8 rounded-xl border border-[var(--line)] bg-[var(--surface)] p-6 backdrop-blur">
          <OnboardingForm
            initialLanguages={profile.preferred_languages ?? []}
          />
        </div>
      </main>
    </div>
  );
}
