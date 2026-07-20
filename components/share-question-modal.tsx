"use client";

import { useEffect, useState } from "react";
import { X } from "lucide-react";
import type { FriendLeaderboardRow } from "@/lib/types/database";

type FriendsResponse = {
  friend_code: string;
  invite_path: string;
  leaderboard: FriendLeaderboardRow[];
};

export function ShareQuestionModal({
  questionId,
  open,
  onClose,
}: {
  questionId: string;
  open: boolean;
  onClose: () => void;
}) {
  const [friends, setFriends] = useState<FriendLeaderboardRow[]>([]);
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);

  useEffect(() => {
    if (!open) return;

    setError(null);
    setMessage(null);
    setSelected(new Set());
    setLoading(true);

    void (async () => {
      const res = await fetch("/api/friends");
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        setError(body.error ?? "Could not load friends.");
        setLoading(false);
        return;
      }

      const body = (await res.json()) as FriendsResponse;
      setFriends(body.leaderboard.filter((row) => !row.is_self));
      setLoading(false);
    })();
  }, [open]);

  if (!open) return null;

  function toggleFriend(friendId: string) {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(friendId)) next.delete(friendId);
      else next.add(friendId);
      return next;
    });
  }

  async function share() {
    if (selected.size === 0) {
      setError("Select at least one friend.");
      return;
    }

    setSubmitting(true);
    setError(null);
    setMessage(null);

    const res = await fetch("/api/questions/share", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        question_id: questionId,
        friend_ids: [...selected],
      }),
    });

    const body = await res.json().catch(() => ({}));
    setSubmitting(false);

    if (!res.ok) {
      setError(body.error ?? "Could not share question.");
      return;
    }

    const count = body.shared_count ?? selected.size;
    setMessage(
      count === 1
        ? "Challenge sent to 1 friend."
        : `Challenge sent to ${count} friends.`,
    );
    setTimeout(() => onClose(), 1200);
  }

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4 backdrop-blur-sm"
      role="dialog"
      aria-modal="true"
      aria-labelledby="share-question-title"
      onClick={onClose}
    >
      <div
        className="w-full max-w-md rounded-xl border border-[var(--line)] bg-[#fffdf8] p-6 shadow-2xl"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-start justify-between gap-4">
          <div>
            <h2
              id="share-question-title"
              className="font-[family-name:var(--font-display)] text-2xl"
            >
              Challenge a friend
            </h2>
            <p className="mt-1 text-sm text-[var(--ink-muted)]">
              Send this question to friends from your list.
            </p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="rounded-md p-1 text-[var(--ink-muted)] hover:bg-[var(--bg-deep)] hover:text-[var(--ink)]"
            aria-label="Close"
          >
            <X className="h-5 w-5" aria-hidden />
          </button>
        </div>

        <div className="mt-5 max-h-64 space-y-2 overflow-y-auto">
          {loading ? (
            <p className="text-sm text-[var(--ink-muted)]">Loading friends…</p>
          ) : friends.length === 0 ? (
            <p className="text-sm text-[var(--ink-muted)]">
              Add friends on your profile to share challenges.
            </p>
          ) : (
            friends.map((friend) => (
              <label
                key={friend.id}
                className="flex cursor-pointer items-center gap-3 rounded-lg border border-[var(--line)] px-3 py-2 hover:border-[var(--ink-muted)]"
              >
                <input
                  type="checkbox"
                  checked={selected.has(friend.id)}
                  onChange={() => toggleFriend(friend.id)}
                  className="accent-[var(--accent)]"
                />
                <span className="text-sm font-medium">
                  {friend.display_name ?? "Anonymous"}
                </span>
              </label>
            ))
          )}
        </div>

        {error && <p className="mt-3 text-sm text-[var(--danger)]">{error}</p>}
        {message && <p className="mt-3 text-sm text-[var(--ok)]">{message}</p>}

        <div className="mt-5 flex justify-end gap-2">
          <button
            type="button"
            onClick={onClose}
            className="rounded-md px-4 py-2 text-sm font-semibold text-[var(--ink-muted)]"
          >
            Cancel
          </button>
          <button
            type="button"
            disabled={submitting || friends.length === 0}
            onClick={() => void share()}
            className="rounded-md bg-[var(--accent)] px-4 py-2 text-sm font-semibold text-white hover:bg-[var(--accent-strong)] disabled:opacity-50"
          >
            {submitting ? "Sending…" : "Send challenge"}
          </button>
        </div>
      </div>
    </div>
  );
}
