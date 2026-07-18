---
name: codesnoop-supabase
description: >-
  CodeSnoop Supabase schema, RLS, migrations, and MCP workflow.
  Use when changing database tables, RLS policies, seeds, or applying migrations.
---

# CodeSnoop Supabase

Project URL: `https://gpmcdhumlvaxjmqifmzr.supabase.co`

## Tables (MVP)

- `profiles` — auth.users mirror; points, streak, preferred_languages, role, onboarding_completed
- `questions` — snippets + MCQ; only `published` readable by users
- `question_attempts` — per-user answers
- `user_stats` — aggregates by user/language/topic/difficulty

## RLS rules

- Profiles: users select/update own row (cannot change `role`)
- Questions: authenticated select where `status = 'published'`; admins full access
- Attempts: users insert/select own rows
- user_stats: users select own rows; updates via service/API logic

## Migration workflow

1. Edit SQL under `supabase/migrations/`
2. Apply with Supabase MCP `apply_migration` (name + query)
3. Verify with `list_tables` / `get_advisors`
4. Prefer local SQL files as source of truth

## Auth

- Providers: GitHub + email magic link
- Site URL / redirect: `http://localhost:3000/auth/callback` (dev)
- Env: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`

## Security notes

- Never return `correct_option_index` from `/api/questions/next`
- Grade answers server-side only
- Keep role changes admin-only (DB trigger or policy)
