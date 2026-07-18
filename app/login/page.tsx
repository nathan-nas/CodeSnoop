import { Suspense } from "react";
import Link from "next/link";
import { SiteHeader } from "@/components/site-header";
import { LoginForm } from "@/components/login-form";

export default function LoginPage() {
  return (
    <div className="relative flex min-h-screen flex-col">
      <div className="pointer-events-none absolute inset-0 grid-noise opacity-50" />
      <SiteHeader
        right={
          <Link href="/" className="text-sm text-[var(--ink-muted)] hover:text-[var(--ink)]">
            Back
          </Link>
        }
      />
      <main className="relative z-10 mx-auto flex w-full max-w-md flex-1 flex-col justify-center px-6 pb-16">
        <h1 className="font-[family-name:var(--font-display)] text-4xl tracking-tight">
          Sign in
        </h1>
        <p className="mt-2 text-[var(--ink-muted)]">
          GitHub, email + password, or a magic link for first-time setup.
        </p>
        <div className="mt-8 rounded-xl border border-[var(--line)] bg-[var(--surface)] p-6 backdrop-blur">
          <Suspense fallback={<p className="text-sm text-[var(--ink-muted)]">Loading…</p>}>
            <LoginForm />
          </Suspense>
        </div>
      </main>
    </div>
  );
}
