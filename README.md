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

Never commit `.env.local`. Secrets stay in Vercel project env vars for production.

2. In Supabase Auth → URL configuration, allow both local and production:

| Setting | Value |
|---------|--------|
| Site URL | `https://codesnoop.vercel.app` |
| Redirect URLs | `http://localhost:3000/auth/callback` |
| | `https://codesnoop.vercel.app/auth/callback` |
| | `https://codesnoop.vercel.app/**` |

Enable **GitHub** and **Email** providers. For GitHub OAuth App, the Authorization callback URL is always:

`https://gpmcdhumlvaxjmqifmzr.supabase.co/auth/v1/callback`

3. Install and run:

```bash
npm install
npm run dev
```

## Production (Vercel)

- App: https://codesnoop.vercel.app
- Project: `anh-ng/codesnoop`
- Env vars (set in Vercel, not git): `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`

```bash
npx vercel env add NEXT_PUBLIC_SUPABASE_URL
npx vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY
npx vercel --prod
```

The anon/publishable key is safe to expose to the browser (`NEXT_PUBLIC_`) because Row Level Security enforces access. Never put the **service role** key in `NEXT_PUBLIC_` or the client.

## MVP routes

| Route | Purpose |
|-------|---------|
| `/` | Landing |
| `/login` | GitHub, email/password, or magic link |
| `/setup` | Account setup (name, password, languages) after first magic link |
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
