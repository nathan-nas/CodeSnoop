import { redirect } from "next/navigation";

/** @deprecated Use /setup */
export default function OnboardingRedirectPage() {
  redirect("/setup");
}
