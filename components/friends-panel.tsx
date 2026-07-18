"use client";

import { useCallback, useEffect, useState } from "react";
import type { FriendLeaderboardRow } from "@/lib/types/database";

type FriendsResponse = {
  friend_code: string;
  invite_path: string;
  leaderboard: FriendLeaderboardRow[];
};

export function FriendsPanel({
  highlight,
  initialError,
}: {
  highlight?: boolean;
  initialError?: string | null;
}) {
  const [data, setData] = useState<FriendsResponse | null>(null);
  const [code, setCode] = useState("");
  const [error, setError] = useState<string | null>(initialError ?? null);
  const [message, setMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [copied, setCopied] = useState(false);

  const load = useCallback(async () => {
    const res = await fetch("/api/friends");
    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "Could not load friends.");
      return;
    }
    const json = (await res.json()) as FriendsResponse;
    setData(json);
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  async function copyInvite() {
    if (!data) return;
    const url = `${window.location.origin}${data.invite_path}`;
    try {
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      setError("Could not copy link.");
    }
  }

  async function addFriend(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setMessage(null);
    setLoading(true);
    const res = await fetch("/api/friends", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ code }),
    });
    const body = await res.json().catch(() => ({}));
    setLoading(false);
    if (!res.ok) {
      setError(body.error ?? "Could not add friend.");
      return;
    }
    setCode("");
    setMessage(
      body.friend?.display_name
        ? `Added ${body.friend.display_name}.`
        : "Friend added.",
    );
    await load();
  }

  async function removeFriend(friendId: string) {
    setError(null);
    setMessage(null);
    const res = await fetch("/api/friends", {
      method: "DELETE",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ friend_id: friendId }),
    });
    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      setError(body.error ?? "Could not remove friend.");
      return;
    }
    setMessage("Friend removed.");
    await load();
  }

  return (
    <section
      id="friends"
      className={highlight ? "scroll-mt-8 rounded-xl ring-2 ring-[var(--accent)] ring-offset-4 ring-offset-[var(--bg)]" : undefined}
    >
      <h2 className="font-[family-name:var(--font-display)] text-2xl">
        Friends
      </h2>
      <p className="mt-1 text-sm text-[var(--ink-muted)]">
        Share your invite link or code. Compete on points and daily streak.
      </p>

      {data && (
        <div className="mt-4 space-y-3 rounded-xl border border-[var(--line)] bg-[var(--surface)] p-5 backdrop-blur">
          <div className="flex flex-wrap items-end justify-between gap-3">
            <div>
              <p className="text-xs uppercase tracking-wide text-[var(--ink-muted)]">
                Your code
              </p>
              <p className="mt-1 font-[family-name:var(--font-code)] text-2xl tracking-wider">
                {data.friend_code}
              </p>
            </div>
            <button
              type="button"
              onClick={() => void copyInvite()}
              className="rounded-md border border-[var(--line)] bg-white/70 px-4 py-2 text-sm font-semibold hover:border-[var(--ink-muted)]"
            >
              {copied ? "Copied!" : "Copy invite link"}
            </button>
          </div>
        </div>
      )}

      <form onSubmit={addFriend} className="mt-5 flex flex-wrap gap-2">
        <input
          type="text"
          value={code}
          onChange={(e) => setCode(e.target.value.toUpperCase())}
          placeholder="Friend’s code"
          maxLength={32}
          className="min-w-[12rem] flex-1 rounded-md border border-[var(--line)] bg-white/80 px-3 py-2 font-[family-name:var(--font-code)] tracking-wider outline-none ring-[var(--accent)] focus:ring-2"
        />
        <button
          type="submit"
          disabled={loading || !code.trim()}
          className="rounded-md bg-[var(--accent)] px-4 py-2 text-sm font-semibold text-white hover:bg-[var(--accent-strong)] disabled:opacity-60"
        >
          {loading ? "Adding…" : "Add friend"}
        </button>
      </form>

      {error && <p className="mt-3 text-sm text-[var(--danger)]">{error}</p>}
      {message && <p className="mt-3 text-sm text-[var(--ok)]">{message}</p>}

      <div className="mt-6 overflow-x-auto rounded-xl border border-[var(--line)] bg-[var(--surface)] backdrop-blur">
        <table className="w-full min-w-[20rem] text-left text-sm">
          <thead>
            <tr className="border-b border-[var(--line)] text-xs uppercase tracking-wide text-[var(--ink-muted)]">
              <th className="px-4 py-3 font-medium">#</th>
              <th className="px-4 py-3 font-medium">Name</th>
              <th className="px-4 py-3 font-medium">Points</th>
              <th className="px-4 py-3 font-medium">Streak</th>
              <th className="px-4 py-3 font-medium" />
            </tr>
          </thead>
          <tbody>
            {(data?.leaderboard ?? []).length === 0 ? (
              <tr>
                <td
                  colSpan={5}
                  className="px-4 py-6 text-[var(--ink-muted)]"
                >
                  Loading leaderboard…
                </td>
              </tr>
            ) : (
              data!.leaderboard.map((row, i) => (
                <tr
                  key={row.id}
                  className={`border-b border-[var(--line)] last:border-0 ${
                    row.is_self ? "bg-[rgba(15,110,86,0.06)]" : ""
                  }`}
                >
                  <td className="px-4 py-3 text-[var(--ink-muted)]">{i + 1}</td>
                  <td className="px-4 py-3 font-medium">
                    {row.display_name ?? "Anonymous"}
                    {row.is_self ? (
                      <span className="ml-2 text-xs text-[var(--accent)]">
                        you
                      </span>
                    ) : null}
                  </td>
                  <td className="px-4 py-3">{row.total_points}</td>
                  <td className="px-4 py-3">{row.daily_streak}d</td>
                  <td className="px-4 py-3 text-right">
                    {!row.is_self && (
                      <button
                        type="button"
                        onClick={() => void removeFriend(row.id)}
                        className="text-xs text-[var(--ink-muted)] hover:text-[var(--danger)]"
                      >
                        Remove
                      </button>
                    )}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </section>
  );
}
