export type Language = "java" | "javascript";
export type Difficulty = "easy" | "medium" | "hard";
export type QuestionStatus = "draft" | "published" | "rejected";
export type UserRole = "user" | "admin";

export type Profile = {
  id: string;
  created_at: string;
  updated_at: string;
  display_name: string | null;
  preferred_languages: Language[];
  preferred_topics: string[];
  friend_code: string;
  total_points: number;
  daily_streak: number;
  last_active_at: string | null;
  role: UserRole;
  onboarding_completed: boolean;
};

export type Friendship = {
  user_id: string;
  friend_id: string;
  created_at: string;
};

export type FriendLeaderboardRow = {
  id: string;
  display_name: string | null;
  total_points: number;
  daily_streak: number;
  is_self: boolean;
};

export type QuestionOption = {
  text: string;
};

export type Question = {
  id: string;
  created_at: string;
  updated_at: string;
  status: QuestionStatus;
  language: Language;
  difficulty: Difficulty;
  topic_tags: string[];
  skill_type: string | null;
  snippet_code: string;
  snippet_language: string;
  snippet_context_before: string | null;
  snippet_context_after: string | null;
  question_stem: string;
  options: QuestionOption[];
  correct_option_index: number;
  explanation: string;
  thought_process: string;
  source_repo_url: string | null;
  source_file_path: string | null;
  source_commit_hash: string | null;
  source_license: string | null;
  created_by: string | null;
};

export type PublicQuestion = Omit<
  Question,
  "correct_option_index" | "explanation" | "thought_process"
>;

export type QuestionAttempt = {
  id: string;
  created_at: string;
  user_id: string;
  question_id: string;
  selected_option_index: number;
  is_correct: boolean;
  time_taken_ms: number | null;
  points_awarded: number;
};

export type UserStat = {
  user_id: string;
  language: Language;
  topic: string;
  difficulty: Difficulty;
  questions_answered: number;
  questions_correct: number;
  accuracy: number;
};
