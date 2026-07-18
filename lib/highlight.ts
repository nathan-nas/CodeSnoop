import { codeToHtml } from "shiki";

export async function highlightCode(code: string, language: string) {
  const lang = language === "java" ? "java" : "javascript";
  return codeToHtml(code, {
    lang,
    theme: "github-light",
  });
}
