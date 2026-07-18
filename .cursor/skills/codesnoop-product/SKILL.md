---
name: codesnoop-product
description: >-
  CodeSnoop product model, scoring, user flows, and MVP vs later phases.
  Use when building features, APIs, UI routes, or deciding scope for CodeSnoop.
---

# CodeSnoop Product

Tiny web app that trains code reading with short snippets (Java, JavaScript). Users answer MCQs, see explanations + thought process, earn points.

## MVP scope (ship first)

- Auth: GitHub OAuth + email magic link (Supabase Auth)
- Onboarding: preferred languages only (no calibration quiz yet)
- Practice loop: next question → answer → explanation
- Dashboard: points, streak, today progress, topic accuracy
- Manual seed questions (no crawler, no admin UI, no challenge mode)

## Scoring

- Correct: base 10 + difficulty bonus (easy +0, medium +5, hard +10)
- Incorrect: 0 points (still log attempt)
- Daily streak: increment if last active was yesterday; reset if gap > 1 day

## Question model (essentials)

- language: `java` | `javascript`
- difficulty: `easy` | `medium` | `hard`
- status: `draft` | `published` | `rejected`
- options (jsonb), correct_option_index (never expose until after answer)
- explanation, thought_process, topic_tags, skill_type, source metadata

## Routes

`/`, `/login`, `/auth/callback`, `/onboarding`, `/dashboard`, `/practice`

## Later phases (do not build unless asked)

1. Admin curation UI
2. GitHub crawler + AI draft questions (`code_files`, `ai_jobs`)
3. Challenge mode, badges, calibration quiz
