import type { Metadata } from "next";
import { Fraunces, IBM_Plex_Mono, Source_Sans_3 } from "next/font/google";
import { HashAuthHandler } from "@/components/hash-auth-handler";
import "./globals.css";

const display = Fraunces({
  variable: "--font-display",
  subsets: ["latin"],
});

const sans = Source_Sans_3({
  variable: "--font-body",
  subsets: ["latin"],
});

const mono = IBM_Plex_Mono({
  variable: "--font-code",
  subsets: ["latin"],
  weight: ["400", "500"],
});

export const metadata: Metadata = {
  title: "CodeSnoop",
  description:
    "Train code reading skills with short, weird snippets from real projects.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${display.variable} ${sans.variable} ${mono.variable} h-full antialiased`}
    >
      <body
        className="min-h-full flex flex-col font-[family-name:var(--font-body)]"
        style={{ fontFamily: "var(--font-body), Georgia, serif" }}
      >
        <HashAuthHandler />
        {children}
      </body>
    </html>
  );
}
