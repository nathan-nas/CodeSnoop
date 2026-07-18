export function CodeBlock({ html }: { html: string }) {
  return (
    <div
      className="overflow-hidden rounded-xl border border-[var(--code-border)] bg-[var(--code-bg)] text-[var(--code-ink)] shadow-[inset_0_1px_0_rgba(255,255,255,0.6)] [&_.shiki]:!bg-transparent"
      dangerouslySetInnerHTML={{ __html: html }}
    />
  );
}
