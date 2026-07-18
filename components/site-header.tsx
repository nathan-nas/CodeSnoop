import Link from "next/link";

export function SiteHeader({
  right,
}: {
  right?: React.ReactNode;
}) {
  return (
    <header className="relative z-10 flex items-center justify-between px-6 py-5 md:px-10">
      <Link
        href="/"
        className="font-[family-name:var(--font-display)] text-xl tracking-tight text-[var(--ink)] md:text-2xl"
      >
        CodeSnoop
      </Link>
      {right}
    </header>
  );
}
