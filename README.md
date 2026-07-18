# CodeSnoop

Train code reading skills with short, weird snippets from real projects. Look at a piece of code, guess what it does (or where it’s broken), then see a clear breakdown of the answer and the thought process behind it.

## Stack

- Next.js (App Router) on Vercel
- Supabase (Auth, Postgres, RLS)
- Tailwind CSS + Shiki

## Local setup

1. Copy env and fill the anon/publishable key from the Supabase dashboard:

```bash
cp .env.local.example .env.local
```

2. In Supabase Auth settings:
   - Enable **GitHub** and **Email** (magic link)
   - Site URL: `http://localhost:3000`
   - Redirect URLs: `http://localhost:3000/auth/callback`

3. Install and run:

```bash
npm install
npm run dev
```

## MVP routes

| Route | Purpose |
|-------|---------|
| `/` | Landing |
| `/login` | GitHub + magic link |
| `/onboarding` | Preferred languages |
| `/dashboard` | Points, streak, progress |
| `/practice` | Main practice loop |

## Database

Migrations live in `supabase/migrations/`:

1. `20260718000001_initial_schema.sql` — tables, RLS, profile trigger
2. `20260718000002_seed_questions.sql` — 8 published practice questions

Apply with Supabase MCP `apply_migration`, the SQL editor, or `supabase db push` once the project is online. If the project was paused, restore it in the Supabase dashboard first.

### Auth providers

In **Authentication → Providers**:

- Enable **GitHub** (set Client ID / Secret from a GitHub OAuth App)
- Enable **Email** magic links

Redirect URL: `http://localhost:3000/auth/callback`
