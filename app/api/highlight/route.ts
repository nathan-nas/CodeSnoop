import { NextResponse } from "next/server";
import { highlightCode } from "@/lib/highlight";

export async function POST(request: Request) {
  const body = await request.json();
  const code = typeof body.code === "string" ? body.code : "";
  const language = typeof body.language === "string" ? body.language : "javascript";

  if (!code) {
    return NextResponse.json({ error: "code required" }, { status: 400 });
  }

  const html = await highlightCode(code, language);
  return NextResponse.json({ html });
}
