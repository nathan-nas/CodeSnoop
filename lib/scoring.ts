import type { Difficulty } from "@/lib/types/database";

const BASE_POINTS = 10;
const DIFFICULTY_BONUS: Record<Difficulty, number> = {
  easy: 0,
  medium: 5,
  hard: 10,
};

export function computePoints(isCorrect: boolean, difficulty: Difficulty): number {
  if (!isCorrect) return 0;
  return BASE_POINTS + DIFFICULTY_BONUS[difficulty];
}

/** Returns updated streak given previous streak and last_active_at ISO timestamp. */
export function computeStreak(
  previousStreak: number,
  lastActiveAt: string | null,
  now = new Date(),
): number {
  if (!lastActiveAt) return 1;

  const last = new Date(lastActiveAt);
  const startOfToday = new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()),
  );
  const startOfLast = new Date(
    Date.UTC(last.getUTCFullYear(), last.getUTCMonth(), last.getUTCDate()),
  );
  const diffDays = Math.round(
    (startOfToday.getTime() - startOfLast.getTime()) / (24 * 60 * 60 * 1000),
  );

  if (diffDays === 0) return previousStreak || 1;
  if (diffDays === 1) return previousStreak + 1;
  return 1;
}
