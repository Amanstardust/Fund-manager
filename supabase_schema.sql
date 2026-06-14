-- AnalystOS Supabase Schema
-- Use this later when upgrading from zero-cost static MVP to free Supabase backend.
-- Run inside Supabase SQL Editor.

create extension if not exists "uuid-ossp";

-- Profiles linked to Supabase auth.users
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  email text,
  timezone text default 'Asia/Kolkata',
  daily_study_hours numeric default 3,
  current_skill_level text default 'Beginner',
  goal text default 'MNC Data Analyst Role',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.semesters (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  order_no int not null,
  duration_weeks int default 13,
  description text,
  main_outcome text,
  unlock_threshold int default 80,
  created_at timestamptz default now()
);

create table if not exists public.modules (
  id uuid primary key default uuid_generate_v4(),
  semester_id uuid references public.semesters(id) on delete cascade,
  title text not null,
  order_no int not null,
  difficulty text,
  skill_area text,
  estimated_hours numeric default 6,
  description text,
  created_at timestamptz default now()
);

create table if not exists public.lessons (
  id uuid primary key default uuid_generate_v4(),
  module_id uuid references public.modules(id) on delete cascade,
  title text not null,
  content text,
  hindi_intuition text,
  business_use text,
  example text,
  order_no int not null,
  created_at timestamptz default now()
);

create table if not exists public.tasks (
  id uuid primary key default uuid_generate_v4(),
  lesson_id uuid references public.lessons(id) on delete cascade,
  title text not null,
  type text default 'practice',
  instructions text,
  estimated_minutes int default 30,
  required_for_completion boolean default true,
  created_at timestamptz default now()
);

create table if not exists public.assessments (
  id uuid primary key default uuid_generate_v4(),
  semester_id uuid references public.semesters(id) on delete cascade,
  module_id uuid references public.modules(id) on delete set null,
  title text not null,
  type text default 'quiz',
  max_score int default 100,
  weight numeric default 20,
  created_at timestamptz default now()
);

create table if not exists public.user_progress (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  entity_type text not null check (entity_type in ('semester','module','lesson','task','project','week')),
  entity_id text not null,
  status text default 'not_started',
  progress_percent int default 0,
  completed_at timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(user_id, entity_type, entity_id)
);

create table if not exists public.quiz_attempts (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  assessment_id uuid references public.assessments(id) on delete cascade,
  skill_area text,
  topic text,
  score numeric not null,
  max_score numeric default 100,
  notes text,
  attempted_at timestamptz default now()
);

create table if not exists public.weak_areas (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  skill_area text not null,
  topic text not null,
  severity text default 'Medium',
  reason text,
  status text default 'open',
  created_at timestamptz default now(),
  resolved_at timestamptz
);

create table if not exists public.revision_queue (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  lesson_id uuid references public.lessons(id) on delete cascade,
  weak_area_id uuid references public.weak_areas(id) on delete set null,
  due_date date not null,
  stage text default 'R1',
  status text default 'pending',
  created_at timestamptz default now(),
  completed_at timestamptz
);

create table if not exists public.projects (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  semester_no int,
  status text default 'planned',
  problem_statement text,
  tools text,
  github_url text,
  dashboard_url text,
  dataset_url text,
  insights text,
  recommendations text,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.job_readiness (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade unique,
  sql_score numeric default 0,
  excel_score numeric default 0,
  powerbi_score numeric default 0,
  python_stats_score numeric default 0,
  portfolio_score numeric default 0,
  interview_score numeric default 0,
  overall_score numeric default 0,
  updated_at timestamptz default now()
);

create table if not exists public.job_applications (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  company text not null,
  role text not null,
  job_url text,
  status text default 'Wishlist',
  applied_date date,
  referral_contact text,
  follow_up_date date,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Row Level Security
alter table public.profiles enable row level security;
alter table public.user_progress enable row level security;
alter table public.quiz_attempts enable row level security;
alter table public.weak_areas enable row level security;
alter table public.revision_queue enable row level security;
alter table public.projects enable row level security;
alter table public.job_readiness enable row level security;
alter table public.job_applications enable row level security;

-- Public curriculum tables can be readable by everyone.
alter table public.semesters enable row level security;
alter table public.modules enable row level security;
alter table public.lessons enable row level security;
alter table public.tasks enable row level security;
alter table public.assessments enable row level security;

create policy "Read curriculum semesters" on public.semesters for select using (true);
create policy "Read curriculum modules" on public.modules for select using (true);
create policy "Read curriculum lessons" on public.lessons for select using (true);
create policy "Read curriculum tasks" on public.tasks for select using (true);
create policy "Read curriculum assessments" on public.assessments for select using (true);

-- User-owned policies
create policy "Profiles are user owned" on public.profiles for all using (auth.uid() = id) with check (auth.uid() = id);
create policy "Progress is user owned" on public.user_progress for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Quiz attempts are user owned" on public.quiz_attempts for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Weak areas are user owned" on public.weak_areas for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Revision queue is user owned" on public.revision_queue for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Projects are user owned" on public.projects for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Job readiness is user owned" on public.job_readiness for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Job applications are user owned" on public.job_applications for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Automatic profile creation after signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, email)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', ''), new.email);
  insert into public.job_readiness (user_id) values (new.id);
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Seed 4 semesters
insert into public.semesters (title, order_no, duration_weeks, description, main_outcome)
values
('Analytics Foundation + Excel + Business Thinking', 1, 13, 'Core analyst thinking, Excel reporting, data cleaning, and metric intuition.', 'Excel Business Performance Dashboard'),
('SQL Mastery + Database Analytics', 2, 13, 'Interview-ready SQL for business analytics with joins, CTEs, windows, and case studies.', 'E-commerce SQL Business Case Study'),
('Power BI + Python + Statistics + EDA', 3, 13, 'BI dashboards, Python analysis, statistics intuition, and storytelling.', 'Executive BI Dashboard + Python EDA Case Study'),
('Portfolio Capstone + Placement Preparation', 4, 13, 'Portfolio projects, resume, interviews, and application tracking.', 'End-to-End Portfolio + MNC Interview System')
on conflict do nothing;
