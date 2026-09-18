-- StudentHub V12: cloud-synced student data
-- Run this in Supabase Dashboard -> SQL Editor.
-- This table stores only the signed-in user's StudentHub data.

create table if not exists public.student_cloud (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  favorites jsonb not null default '[]'::jsonb,
  dashboard jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.student_cloud enable row level security;

-- Because your project was created with automatic exposure of new tables OFF,
-- explicitly grant only authenticated users access to this table.
revoke all on table public.student_cloud from anon;
grant select, insert, update, delete on table public.student_cloud to authenticated;

drop policy if exists "Users can read their own StudentHub cloud data" on public.student_cloud;
drop policy if exists "Users can insert their own StudentHub cloud data" on public.student_cloud;
drop policy if exists "Users can update their own StudentHub cloud data" on public.student_cloud;
drop policy if exists "Users can delete their own StudentHub cloud data" on public.student_cloud;

create policy "Users can read their own StudentHub cloud data"
on public.student_cloud for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can insert their own StudentHub cloud data"
on public.student_cloud for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update their own StudentHub cloud data"
on public.student_cloud for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Users can delete their own StudentHub cloud data"
on public.student_cloud for delete
to authenticated
using ((select auth.uid()) = user_id);
