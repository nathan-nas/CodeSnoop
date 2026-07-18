import { codeToHtml } from "shiki";

export async function highlightCode(code: string, language: string) {
  const lang =
    language === "java" || language === "aem"
      ? "java"
      : language === "javascript"
        ? "javascript"
        : "text";
  return codeToHtml(code, {
    lang,
    theme: "github-light",
  });
}
