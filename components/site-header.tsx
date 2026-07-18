import Image from "next/image";
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
        className="flex items-center gap-2.5 font-[family-name:var(--font-display)] text-xl tracking-tight text-[var(--ink)] md:text-2xl"
      >
        <Image
          src="/brand/codesnoop-icon.png"
          alt=""
          width={32}
          height={32}
          className="size-8 rounded-lg"
          priority
        />
        CodeSnoop
      </Link>
      {right}
    </header>
  );
}
