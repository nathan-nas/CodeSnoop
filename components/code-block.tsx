export function CodeBlock({ html }: { html: string }) {
  return (
    <div
      className="overflow-hidden rounded-xl border border-[var(--line)] bg-[var(--code-bg)] text-[var(--code-ink)] shadow-sm [&_.shiki]:!bg-transparent"
      dangerouslySetInnerHTML={{ __html: html }}
    />
  );
}
