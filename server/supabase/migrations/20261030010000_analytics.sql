-- Demand signals for the owner dashboard, and the support tool's only door
-- into a wardrobe.
--
-- The phone works out the missing pieces itself (missing_piece.dart). Only
-- users who turned on "Help us improve offers" send them here, as a category
-- and a colour: no photo, no item, nothing from the lingerie section.
-- The dashboard reads the views in the analytics schema, and every number in
-- them comes from a group of at least 50 users.

create table public.demand_signals (
  user_id uuid not null references auth.users (id) on delete cascade,
  category text not null check (category in (
    'top', 'bottom', 'onePiece', 'outerwear', 'shoes', 'bag', 'headscarf', 'shemagh',
    'belt', 'watch', 'jewelry', 'sunglasses', 'perfume', 'cap', 'beanie', 'turban',
    'neckScarf', 'accessory')),
  color text not null,
  reported_at timestamptz not null default now(),
  primary key (user_id, category, color)
);

alter table public.demand_signals enable row level security;

-- Users write and clear their own signals, and only while sharing is on.
create policy own_signals on public.demand_signals for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()) and exists (
    select 1 from public.profiles p where p.id = (select auth.uid()) and p.share_demand));

-- Turning sharing off deletes what was sent.
create function public.clear_signals_when_sharing_stops() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  if old.share_demand and not new.share_demand then
    delete from public.demand_signals where user_id = new.id;
  end if;
  return new;
end $$;
create trigger clear_signals_when_sharing_stops after update of share_demand on public.profiles
  for each row execute function public.clear_signals_when_sharing_stops();

create schema analytics;
revoke all on schema analytics from public;
grant usage on schema analytics to service_role;

-- Opted-in users, with the segment and city the dashboard groups by.
create view analytics.panel as
  select p.id as user_id,
         case p.gender when 'female' then 'women' else 'men' end as segment,
         p.city
  from public.profiles p
  where p.share_demand;

create view analytics.missing_pieces as
  with seg as (select segment, count(*) as users from analytics.panel group by segment)
  select seg.segment, s.category,
         round(count(distinct s.user_id)::numeric / seg.users, 2) as share_missing,
         seg.users as panel_users
  from public.demand_signals s
  join analytics.panel pn using (user_id)
  join seg using (segment)
  where seg.users >= 50
  group by seg.segment, s.category, seg.users;

create view analytics.missing_colors as
  with seg as (select segment, count(*) as users from analytics.panel group by segment)
  select seg.segment, s.color,
         round(count(distinct s.user_id)::numeric / seg.users, 2) as share_missing,
         seg.users as panel_users
  from public.demand_signals s
  join analytics.panel pn using (user_id)
  join seg using (segment)
  where seg.users >= 50
  group by seg.segment, s.color, seg.users;

create view analytics.city_demand as
  with city as (select city, count(*) as users from analytics.panel group by city having count(*) >= 50),
  pieces as (
    select pn.city, s.category, count(distinct s.user_id) as n,
           row_number() over (partition by pn.city order by count(distinct s.user_id) desc, s.category) as r
    from public.demand_signals s join analytics.panel pn using (user_id)
    group by pn.city, s.category),
  colors as (
    select pn.city, s.color,
           row_number() over (partition by pn.city order by count(distinct s.user_id) desc, s.color) as r
    from public.demand_signals s join analytics.panel pn using (user_id)
    group by pn.city, s.color)
  select city.city, city.users as opted_in_users,
         colors.color as top_missing_color,
         pieces.category as top_missing_piece,
         round(pieces.n::numeric / city.users, 2) as share_missing_piece
  from city
  left join pieces on pieces.city = city.city and pieces.r = 1
  left join colors on colors.city = city.city and colors.r = 1;

-- Weekly activity from everyone (counts only, no opt-in needed for those).
-- A week with fewer than 50 active users is left out.
create view analytics.weekly as
  with weeks as (
    select date_trunc('week', worn_at)::date as week, count(distinct user_id) as active_users
    from public.wear_log group by 1),
  signups as (
    select date_trunc('week', u.created_at)::date as week,
           count(*) as joined,
           count(*) filter (where exists (
             select 1 from public.wear_log w
             where w.user_id = u.id and w.worn_at >= u.created_at + interval '7 days')) as came_back
    from public.profiles u group by 1),
  polls as (
    select date_trunc('week', created_at)::date as week, count(*) as polls_sent
    from public.polls group by 1)
  select weeks.week, weeks.active_users,
         case when signups.joined >= 50 then round(signups.came_back::numeric / signups.joined, 2) end as retained_d7,
         coalesce(polls.polls_sent, 0) as polls_sent
  from weeks
  left join signups using (week)
  left join polls using (week)
  where weeks.active_users >= 50;

revoke all on all tables in schema analytics from public, anon, authenticated;
grant select on all tables in schema analytics to service_role;

-- The support tool opens a wardrobe only through this function. It checks the
-- user's grant (not expired, not revoked, and covering the items), writes the
-- access log entry the user can see, and returns those items.
create function public.support_open(p_grant bigint, p_staff text, p_items text[])
returns setof public.items
language plpgsql security definer set search_path = '' as $$
declare
  g public.support_grants;
begin
  select * into g from public.support_grants where id = p_grant;
  if not found or g.revoked_at is not null or g.expires_at <= now() then
    raise exception 'no active grant';
  end if;
  if g.item_ids is not null and not (p_items <@ g.item_ids) then
    raise exception 'items outside the grant';
  end if;
  insert into public.access_log (user_id, grant_id, staff, item_ids)
    values (g.user_id, g.id, p_staff, p_items);
  return query select * from public.items i where i.user_id = g.user_id and i.id = any (p_items);
end $$;
revoke all on function public.support_open(bigint, text, text[]) from public, anon, authenticated;
grant execute on function public.support_open(bigint, text, text[]) to service_role;
