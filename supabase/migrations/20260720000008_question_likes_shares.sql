-- Liked questions and friend challenges (shares)

CREATE TABLE IF NOT EXISTS public.question_likes (
  user_id UUID NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.questions (id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, question_id)
);

CREATE INDEX IF NOT EXISTS question_likes_user_created_idx
  ON public.question_likes (user_id, created_at DESC);

ALTER TABLE public.question_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY question_likes_select_own
  ON public.question_likes FOR SELECT
  TO authenticated
  USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY question_likes_insert_own
  ON public.question_likes FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY question_likes_delete_own
  ON public.question_likes FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

CREATE TABLE IF NOT EXISTS public.question_shares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  recipient_id UUID NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.questions (id) ON DELETE CASCADE,
  sender_display_name TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  attempted_at TIMESTAMPTZ,
  CONSTRAINT question_shares_not_self CHECK (sender_id <> recipient_id),
  CONSTRAINT question_shares_unique UNIQUE (sender_id, recipient_id, question_id)
);

CREATE INDEX IF NOT EXISTS question_shares_recipient_pending_idx
  ON public.question_shares (recipient_id, created_at ASC)
  WHERE attempted_at IS NULL;

CREATE INDEX IF NOT EXISTS question_shares_sender_idx
  ON public.question_shares (sender_id, created_at DESC);

ALTER TABLE public.question_shares ENABLE ROW LEVEL SECURITY;

CREATE POLICY question_shares_select_participants
  ON public.question_shares FOR SELECT
  TO authenticated
  USING (
    sender_id = auth.uid()
    OR recipient_id = auth.uid()
    OR public.is_admin()
  );

CREATE POLICY question_shares_insert_sender
  ON public.question_shares FOR INSERT
  TO authenticated
  WITH CHECK (
    sender_id = auth.uid()
    AND sender_id <> recipient_id
    AND EXISTS (
      SELECT 1
      FROM public.friendships f
      WHERE f.user_id = LEAST(sender_id, recipient_id)
        AND f.friend_id = GREATEST(sender_id, recipient_id)
    )
  );

CREATE POLICY question_shares_update_recipient
  ON public.question_shares FOR UPDATE
  TO authenticated
  USING (recipient_id = auth.uid())
  WITH CHECK (recipient_id = auth.uid());
