-- Talla: accounts, wardrobe, wear log, polls, and support access.
-- Every table has row-level security: a signed-in user reads and writes only
-- their own rows. The service role (edge functions, support tools) bypasses it.
-- Never stored here: selfies, face photos, skin tone photos, the lingerie section.

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  gender text not null default 'female' check (gender in ('female', 'male')),
  wears_hijab boolean not null default false,
  city text not null default 'Cairo',
  language text check (language in ('egyptian', 'gulf', 'standard', 'english')),
  -- "Help us improve offers": anonymous, aggregated demand signals. Off by default.
  share_demand boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.items (
  user_id uuid not null references auth.users (id) on delete cascade,
  id text not null,
  category text not null,
  color text not null,
  pattern text not null default 'solid',
  season text not null default 'all',
  styles text[] not null default '{}',
  status text not null default 'available' check (status in ('available', 'laundry', 'lent')),
  -- Path in the private "wardrobe" storage bucket: <user_id>/<item_id>.jpg
  photo_path text,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table public.wear_log (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  worn_at timestamptz not null,
  item_ids text[] not null,
  occasion text not null,
  with_whom text
);
create index wear_log_user on public.wear_log (user_id, worn_at desc);

create table public.polls (
  user_id uuid not null references auth.users (id) on delete cascade,
  id text not null,
  created_at timestamptz not null default now(),
  occasion text not null,
  style text not null,
  options jsonb not null,
  winner smallint check (winner in (0, 1)),
  primary key (user_id, id)
);

-- Votes from the WhatsApp link. Voters have no account: an edge function
-- writes them with the service role, one vote per voter token per poll.
create table public.poll_votes (
  poll_owner uuid not null,
  poll_id text not null,
  voter_token text not null,
  option smallint not null check (option in (0, 1)),
  created_at timestamptz not null default now(),
  primary key (poll_owner, poll_id, voter_token),
  foreign key (poll_owner, poll_id) references public.polls (user_id, id) on delete cascade
);

-- "Let support see": the user grants access to some items, or the whole
-- wardrobe, for a limited time. Support tools check this before showing anything.
create table public.support_grants (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  item_ids text[],          -- null means the whole wardrobe
  created_at timestamptz not null default now(),
  expires_at timestamptz not null default now() + interval '72 hours',
  revoked_at timestamptz
);

-- Every time support opens something. Users can read their own entries.
create table public.access_log (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  grant_id bigint references public.support_grants (id),
  staff text not null,
  item_ids text[] not null,
  opened_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.items enable row level security;
alter table public.wear_log enable row level security;
alter table public.polls enable row level security;
alter table public.poll_votes enable row level security;
alter table public.support_grants enable row level security;
alter table public.access_log enable row level security;

create policy own_profile on public.profiles for all to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));
create policy own_items on public.items for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy own_wear_log on public.wear_log for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy own_polls on public.polls for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- Poll owners can read the votes on their own polls; nobody writes from the app.
create policy read_own_votes on public.poll_votes for select to authenticated
  using (poll_owner = (select auth.uid()));

-- Users create, see and revoke their own grants, but cannot extend one.
create policy read_own_grants on public.support_grants for select to authenticated
  using (user_id = (select auth.uid()));
create policy create_own_grants on public.support_grants for insert to authenticated
  with check (user_id = (select auth.uid()) and expires_at <= now() + interval '72 hours');
create policy revoke_own_grants on public.support_grants for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy read_own_access_log on public.access_log for select to authenticated
  using (user_id = (select auth.uid()));

-- A grant can only be revoked, never widened or extended, from the app.
create function public.support_grants_only_revoke() returns trigger
language plpgsql set search_path = '' as $$
begin
  if current_user = 'authenticated' and (
    new.item_ids is distinct from old.item_ids
    or new.expires_at is distinct from old.expires_at
    or new.created_at is distinct from old.created_at
  ) then
    raise exception 'grants can only be revoked';
  end if;
  return new;
end $$;
create trigger support_grants_only_revoke before update on public.support_grants
  for each row execute function public.support_grants_only_revoke();

-- Wardrobe photos: a private bucket, one folder per user.
insert into storage.buckets (id, name, public) values ('wardrobe', 'wardrobe', false)
  on conflict (id) do nothing;
create policy own_wardrobe_photos on storage.objects for all to authenticated
  using (bucket_id = 'wardrobe' and (storage.foldername(name))[1] = (select auth.uid())::text)
  with check (bucket_id = 'wardrobe' and (storage.foldername(name))[1] = (select auth.uid())::text);
