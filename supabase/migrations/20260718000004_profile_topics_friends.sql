-- Preferred topics + friend codes / friendships + leaderboard RPC

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS preferred_topics TEXT[] NOT NULL DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS friend_code TEXT;

CREATE OR REPLACE FUNCTION public.generate_friend_code()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
  chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  result TEXT := '';
  i INT;
BEGIN
  FOR i IN 1..8 LOOP
    result := result || substr(chars, 1 + floor(random() * length(chars))::int, 1);
  END LOOP;
  RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION public.assign_friend_code()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
  code TEXT;
  attempts INT := 0;
BEGIN
  LOOP
    code := public.generate_friend_code();
    EXIT WHEN NOT EXISTS (
      SELECT 1 FROM public.profiles WHERE friend_code = code
    );
    attempts := attempts + 1;
    IF attempts > 20 THEN
      RAISE EXCEPTION 'could not allocate friend_code';
    END IF;
  END LOOP;
  RETURN code;
END;
$$;

-- Backfill existing profiles
UPDATE public.profiles
SET friend_code = public.assign_friend_code()
WHERE friend_code IS NULL;

ALTER TABLE public.profiles
  ALTER COLUMN friend_code SET NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS profiles_friend_code_uidx
  ON public.profiles (friend_code);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name, friend_code)
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data ->> 'full_name',
      NEW.raw_user_meta_data ->> 'name',
      NEW.email
    ),
    public.assign_friend_code()
  );
  RETURN NEW;
END;
$$;

CREATE TABLE IF NOT EXISTS public.friendships (
  user_id UUID NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  friend_id UUID NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, friend_id),
  CONSTRAINT friendships_ordered CHECK (user_id < friend_id),
  CONSTRAINT friendships_not_self CHECK (user_id <> friend_id)
);

CREATE INDEX IF NOT EXISTS friendships_friend_id_idx
  ON public.friendships (friend_id);

ALTER TABLE public.friendships ENABLE ROW LEVEL SECURITY;

CREATE POLICY friendships_select_participants
  ON public.friendships FOR SELECT
  TO authenticated
  USING (user_id = auth.uid() OR friend_id = auth.uid());

CREATE POLICY friendships_delete_participants
  ON public.friendships FOR DELETE
  TO authenticated
  USING (user_id = auth.uid() OR friend_id = auth.uid());

-- Inserts go through redeem_friend_code() only (no direct INSERT policy)

CREATE OR REPLACE FUNCTION public.redeem_friend_code(p_code TEXT)
RETURNS TABLE (
  friend_id UUID,
  display_name TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  me UUID := auth.uid();
  other_id UUID;
  other_name TEXT;
  a UUID;
  b UUID;
BEGIN
  IF me IS NULL THEN
    RAISE EXCEPTION 'not authenticated';
  END IF;

  SELECT p.id, p.display_name
  INTO other_id, other_name
  FROM public.profiles p
  WHERE upper(trim(p.friend_code)) = upper(trim(p_code));

  IF other_id IS NULL THEN
    RAISE EXCEPTION 'invalid friend code';
  END IF;

  IF other_id = me THEN
    RAISE EXCEPTION 'cannot add yourself';
  END IF;

  IF other_id < me THEN
    a := other_id;
    b := me;
  ELSE
    a := me;
    b := other_id;
  END IF;

  INSERT INTO public.friendships (user_id, friend_id)
  VALUES (a, b)
  ON CONFLICT DO NOTHING;

  friend_id := other_id;
  display_name := other_name;
  RETURN NEXT;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_friends_leaderboard()
RETURNS TABLE (
  id UUID,
  display_name TEXT,
  total_points INTEGER,
  daily_streak INTEGER,
  is_self BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH me AS (
    SELECT auth.uid() AS uid
  ),
  friend_ids AS (
    SELECT
      CASE
        WHEN f.user_id = me.uid THEN f.friend_id
        ELSE f.user_id
      END AS fid
    FROM public.friendships f
    CROSS JOIN me
    WHERE f.user_id = me.uid OR f.friend_id = me.uid
  ),
  roster AS (
    SELECT me.uid AS pid FROM me
    UNION
    SELECT fid FROM friend_ids
  )
  SELECT
    p.id,
    p.display_name,
    p.total_points,
    p.daily_streak,
    (p.id = (SELECT uid FROM me)) AS is_self
  FROM public.profiles p
  JOIN roster r ON r.pid = p.id
  ORDER BY p.total_points DESC, p.daily_streak DESC, p.display_name ASC NULLS LAST;
$$;

GRANT EXECUTE ON FUNCTION public.redeem_friend_code(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_friends_leaderboard() TO authenticated;
