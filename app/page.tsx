import Link from "next/link";
import { SiteHeader } from "@/components/site-header";

export default function HomePage() {
  return (
    <div className="relative flex min-h-screen flex-col overflow-hidden">
      <div className="pointer-events-none absolute inset-0 grid-noise opacity-70" />
      <SiteHeader
        right={
          <Link
            href="/login"
            className="rounded-md bg-[var(--accent)] px-4 py-2 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)]"
          >
            Sign in to start
          </Link>
        }
      />

      <main className="relative z-10 mx-auto flex w-full max-w-5xl flex-1 flex-col justify-center px-6 pb-20 pt-8 md:px-10">
        <p className="mb-4 font-[family-name:var(--font-display)] text-5xl leading-[0.95] tracking-tight text-[var(--ink)] md:text-7xl lg:text-8xl">
          CodeSnoop
        </p>
        <h1 className="max-w-xl text-xl text-[var(--ink-muted)] md:text-2xl">
          Read short, weird snippets from real projects — then prove you
          understood them.
        </h1>
        <p className="mt-5 max-w-lg text-base leading-relaxed text-[var(--ink-muted)]">
          Multiple choice. Clear explanations. Points and streaks for showing
          up. Java and JavaScript to start.
        </p>
        <div className="mt-10 flex flex-wrap gap-3">
          <Link
            href="/login"
            className="rounded-md bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-white transition hover:bg-[var(--accent-strong)]"
          >
            Sign in to start
          </Link>
          <a
            href="#how"
            className="rounded-md border border-[var(--line)] bg-[var(--surface)] px-5 py-3 text-sm font-semibold text-[var(--ink)] backdrop-blur"
          >
            How it works
          </a>
        </div>
      </main>

      <section
        id="how"
        className="relative z-10 border-t border-[var(--line)] bg-[var(--surface)] px-6 py-14 backdrop-blur md:px-10"
      >
        <div className="mx-auto grid max-w-5xl gap-10 md:grid-cols-3">
          {[
            {
              title: "Look",
              body: "A real-world snippet with syntax highlighting — no toy textbook fluff.",
            },
            {
              title: "Guess",
              body: "What does it do? Where is it broken? Pick from a short multiple-choice set.",
            },
            {
              title: "Learn",
              body: "See the answer, why others fail, and a thought process you can reuse.",
            },
          ].map((item) => (
            <div key={item.title}>
              <h2 className="font-[family-name:var(--font-display)] text-2xl text-[var(--ink)]">
                {item.title}
              </h2>
              <p className="mt-2 text-[var(--ink-muted)]">{item.body}</p>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
