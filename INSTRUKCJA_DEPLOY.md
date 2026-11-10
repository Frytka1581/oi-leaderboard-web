# 🚀 Jak uruchomić stronę Leaderboarda i podpiąć domenę z Name.com?

Leaderboard został zaprojektowany w architekturze **Serverless (Supabase + Vercel / GitHub Pages)** — oznacza to **0 zł kosztów**, zero serwerów do utrzymywania i natychmiastowe ładowanie.

---

### Krok 1: Darmowa Baza Danych (Supabase — 2 minuty)
1. Wejdź na [supabase.com](https://supabase.com) i kliknij **Start your project** (zaloguj się przez GitHub).
2. Kliknij **New project**, nazwij go np. `oi-leaderboard` i ustaw silne hasło bazy.
3. W lewym menu wejdź w **SQL Editor**, kliknij **New query**, wklej zawartość pliku `supabase_schema.sql` (znajdziesz go w tym folderze) i kliknij **Run**.
4. W lewym menu wejdź w **Project Settings** -> **API**:
   - Skopiuj **Project URL** (np. `https://xyz.supabase.co`)
   - Skopiuj **anon / public key** (długi klucz tokenu)

---

### Krok 2: Wrzucenie strony na darmowy hosting (Vercel lub GitHub Pages)

#### Opcja Najszybsza: Vercel (Rekomendowane pod własną domenę z Name.com)
1. Wejdź na [vercel.com](https://vercel.com) i zaloguj się przez GitHub.
2. Kliknij **Add New... -> Project** i zaimportuj repozytorium z tym folderem (lub przeciągnij folder na Vercel).
3. Po wdrożeniu wejdź w **Settings -> Domains** w projekcie na Vercel.
4. Wpisz swoją domenę kupioną na **Name.com** (np. `staszicoi.live`).
5. Vercel pokaże Ci rekordy DNS (zwykle rekord **A** wskazujący na `76.76.21.21` oraz **CNAME** dla `www`).
6. Wejdź na **Name.com -> My Domains -> Twoja domena -> Manage DNS Records** i dodaj te 2 rekordy. W ciągu kilku minut strona będzie działać pod Twoją domeną z darmowym certyfikatem SSL!

---

### Krok 3: Synchronizacja z rozszerzeniem w VS Code
W rozszerzeniu **OI Tracker** dodaliśmy komendę:
`OI Tracker: Połącz z Leaderboardem (Supabase)`
Wystarczy wpisać swój Nick, klasę, URL i Anon Key z Supabase. Wyniki zadań i wirtuali będą synchronizować się w tle!
