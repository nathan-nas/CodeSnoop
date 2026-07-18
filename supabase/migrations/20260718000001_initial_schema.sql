-- CodeSnoop MVP schema

CREATE TYPE public.language AS ENUM ('java', 'javascript');
CREATE TYPE public.difficulty AS ENUM ('easy', 'medium', 'hard');
CREATE TYPE public.question_status AS ENUM ('draft', 'published', 'rejected');
CREATE TYPE public.user_role AS ENUM ('user', 'admin');

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  display_name TEXT,
  preferred_languages public.language[] NOT NULL DEFAULT '{}',
  total_points INTEGER NOT NULL DEFAULT 0,
  daily_streak INTEGER NOT NULL DEFAULT 0,
  last_active_at TIMESTAMPTZ,
  role public.user_role NOT NULL DEFAULT 'user',
  onboarding_completed BOOLEAN NOT NULL DEFAULT false
);

CREATE TRIGGER profiles_set_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data ->> 'full_name', NEW.raw_user_meta_data ->> 'name', NEW.email)
  );
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

CREATE TABLE public.questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  status public.question_status NOT NULL DEFAULT 'draft',
  language public.language NOT NULL,
  difficulty public.difficulty NOT NULL DEFAULT 'medium',
  topic_tags TEXT[] NOT NULL DEFAULT '{}',
  skill_type TEXT,
  snippet_code TEXT NOT NULL,
  snippet_language TEXT NOT NULL,
  snippet_context_before TEXT,
  snippet_context_after TEXT,
  question_stem TEXT NOT NULL,
  options JSONB NOT NULL,
  correct_option_index INTEGER NOT NULL,
  explanation TEXT NOT NULL,
  thought_process TEXT NOT NULL,
  source_repo_url TEXT,
  source_file_path TEXT,
  source_commit_hash TEXT,
  source_license TEXT,
  created_by UUID REFERENCES public.profiles (id) ON DELETE SET NULL,
  CONSTRAINT questions_correct_option_valid CHECK (correct_option_index >= 0),
  CONSTRAINT questions_options_is_array CHECK (jsonb_typeof(options) = 'array')
);

CREATE TRIGGER questions_set_updated_at
  BEFORE UPDATE ON public.questions
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX questions_status_language_idx
  ON public.questions (status, language);

CREATE TABLE public.question_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  user_id UUID NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.questions (id) ON DELETE CASCADE,
  selected_option_index INTEGER NOT NULL,
  is_correct BOOLEAN NOT NULL,
  time_taken_ms INTEGER,
  points_awarded INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX question_attempts_user_created_idx
  ON public.question_attempts (user_id, created_at DESC);

CREATE INDEX question_attempts_user_question_idx
  ON public.question_attempts (user_id, question_id);

CREATE TABLE public.user_stats (
  user_id UUID NOT NULL REFERENCES public.profiles (id) ON DELETE CASCADE,
  language public.language NOT NULL,
  topic TEXT NOT NULL,
  difficulty public.difficulty NOT NULL,
  questions_answered INTEGER NOT NULL DEFAULT 0,
  questions_correct INTEGER NOT NULL DEFAULT 0,
  accuracy DOUBLE PRECISION NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, language, topic, difficulty)
);

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
$$;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.question_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_stats ENABLE ROW LEVEL SECURITY;

CREATE POLICY profiles_select_own
  ON public.profiles FOR SELECT
  TO authenticated
  USING (id = auth.uid() OR public.is_admin());

CREATE POLICY profiles_update_own
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (id = auth.uid())
  WITH CHECK (
    id = auth.uid()
    AND role = (SELECT p.role FROM public.profiles p WHERE p.id = auth.uid())
  );

CREATE POLICY questions_select_published
  ON public.questions FOR SELECT
  TO authenticated
  USING (status = 'published' OR public.is_admin());

CREATE POLICY questions_admin_insert
  ON public.questions FOR INSERT
  TO authenticated
  WITH CHECK (public.is_admin());

CREATE POLICY questions_admin_update
  ON public.questions FOR UPDATE
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

CREATE POLICY questions_admin_delete
  ON public.questions FOR DELETE
  TO authenticated
  USING (public.is_admin());

CREATE POLICY attempts_select_own
  ON public.question_attempts FOR SELECT
  TO authenticated
  USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY attempts_insert_own
  ON public.question_attempts FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY user_stats_select_own
  ON public.user_stats FOR SELECT
  TO authenticated
  USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY user_stats_upsert_own
  ON public.user_stats FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY user_stats_update_own
  ON public.user_stats FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());
