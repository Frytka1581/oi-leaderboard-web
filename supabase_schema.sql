-- =========================================================================
-- OI TRACKER & LEADERBOARD — SUPABASE SCHEMA & SECURITY POLICIES
-- Skopiuj i wklej tę treść do Supabase -> SQL Editor -> Run
-- =========================================================================

-- 1. Tabela Użytkowników Leaderboarda
CREATE TABLE IF NOT EXISTS public.profiles (
    user_key TEXT PRIMARY KEY,                       -- unikalny klucz/identyfikator wygenerowany w VS Code
    nickname TEXT NOT NULL,                          -- np. "Tymek", "Oskar", "Bartek"
    school_class TEXT DEFAULT '3B Staszic',          -- np. "3B", "XIV LO Staszic"
    avatar_color TEXT DEFAULT '#00f2fe',             -- kolor akcentu w rankingu
    total_points INTEGER DEFAULT 0,                 -- suma punktów ze wszystkich zadań
    full_score_tasks INTEGER DEFAULT 0,              -- liczba zrobionych zadań na 100 pkt
    completed_simulations INTEGER DEFAULT 0,         -- liczba ukończonych symulacji 5h
    highest_task_rating INTEGER DEFAULT 0,           -- najwyższy rating z oi-list zrobionego zadania
    highest_task_title TEXT DEFAULT '',              -- tytuł najtrudniejszego zadania
    streak_days INTEGER DEFAULT 1,                   -- liczba aktywnych dni z rzędu
    last_active_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabela Zadań (zrobione zadania przez użytkowników)
CREATE TABLE IF NOT EXISTS public.user_tasks (
    id BIGSERIAL PRIMARY KEY,
    user_key TEXT NOT NULL REFERENCES public.profiles(user_key) ON DELETE CASCADE,
    problem_key TEXT NOT NULL,
    short_code TEXT NOT NULL,
    title TEXT NOT NULL,
    stage SMALLINT DEFAULT 2,                        -- 2 = Etap II, 3 = Etap III
    edition_number SMALLINT NOT NULL,                -- np. 32 dla XXXII OI
    score SMALLINT NOT NULL DEFAULT 0,               -- 0..100
    rating INTEGER,                                  -- rating z oi-list
    rating_color TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT user_problem_unique UNIQUE (user_key, problem_key)
);

-- 3. Tabela Symulacji 5h (Wirtualne etapy)
CREATE TABLE IF NOT EXISTS public.user_simulations (
    id TEXT PRIMARY KEY,                             -- np. "sim_..."
    user_key TEXT NOT NULL REFERENCES public.profiles(user_key) ON DELETE CASCADE,
    stage SMALLINT DEFAULT 2,                        -- 2 lub 3
    edition_number SMALLINT NOT NULL,
    edition_roman TEXT NOT NULL,
    day_id TEXT NOT NULL,                            -- "d0", "d1", "d2"
    day_label TEXT NOT NULL,
    total_points SMALLINT NOT NULL,
    max_points SMALLINT NOT NULL,
    duration_used_ms INTEGER NOT NULL,
    qualified_or_medal BOOLEAN DEFAULT FALSE,
    finished_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Indeksy dla szybkiego sortowania leaderboarda
CREATE INDEX IF NOT EXISTS idx_profiles_points ON public.profiles (total_points DESC, full_score_tasks DESC);
CREATE INDEX IF NOT EXISTS idx_simulations_time ON public.user_simulations (finished_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_tasks_lookup ON public.user_tasks (user_key);

-- 5. Włączenie Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_simulations ENABLE ROW LEVEL SECURITY;

-- 6. Polityki bezpieczeństwa (Publiczny odczyt dla każdego na stronie WWW, zapis/aktualizacja przez klucz anon)
CREATE POLICY "Public profiles are viewable by everyone" 
ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Anyone with user_key can insert or update profile" 
ON public.profiles FOR INSERT WITH CHECK (true);

CREATE POLICY "Profile owner can update" 
ON public.profiles FOR UPDATE USING (true);

CREATE POLICY "Tasks viewable by everyone" 
ON public.user_tasks FOR SELECT USING (true);

CREATE POLICY "Anyone can upsert tasks" 
ON public.user_tasks FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update tasks" 
ON public.user_tasks FOR UPDATE USING (true);

CREATE POLICY "Simulations viewable by everyone" 
ON public.user_simulations FOR SELECT USING (true);

CREATE POLICY "Anyone can insert simulation" 
ON public.user_simulations FOR INSERT WITH CHECK (true);

-- Włączenie Realtime dla tabel (opcjonalne, ale super do dynamicznej tabeli live):
ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_simulations;
