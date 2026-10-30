\set ON_ERROR_STOP on
-- Grants Supabase gives by default; RLS policies decide what each row allows.
grant all on all tables in schema public, storage to authenticated, service_role;
grant all on all sequences in schema public, storage to authenticated, service_role;

insert into auth.users values ('00000000-0000-0000-0000-00000000000a'), ('00000000-0000-0000-0000-00000000000b');

create function pg_temp.expect_denied(sql text, label text) returns void language plpgsql as $$
begin
  execute sql;
  raise exception 'FAIL (allowed): %', label;
exception
  when insufficient_privilege or check_violation or raise_exception then
    if sqlerrm like 'FAIL%' then raise; end if;
    raise notice 'ok  denied: %', label;
end $$;

create function pg_temp.expect(cond boolean, label text) returns void language plpgsql as $$
begin
  if not cond then raise exception 'FAIL: %', label; end if;
  raise notice 'ok  %', label;
end $$;

-- User B has a wardrobe.
set role authenticated;
set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000b';
insert into public.profiles (id) values (auth.uid());
insert into public.items (user_id, id, category, color) values (auth.uid(), 'b1', 'top', 'black');
insert into public.polls (user_id, id, occasion, style, options) values (auth.uid(), 'p1', 'outing', 'casual', '[["b1"],["b1"]]');
insert into storage.objects (bucket_id, name) values ('wardrobe', '00000000-0000-0000-0000-00000000000b/b1.jpg');

-- User A signs in.
set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000a';
insert into public.profiles (id) values (auth.uid());
insert into public.items (user_id, id, category, color) values (auth.uid(), 'a1', 'onePiece', 'burgundy');
select pg_temp.expect((select count(*) from public.items) = 1, 'A sees only her own items');
select pg_temp.expect((select count(*) from public.profiles) = 1, 'A sees only her own profile');
select pg_temp.expect((select count(*) from public.polls) = 0, 'A cannot see B''s polls');
select pg_temp.expect((select count(*) from storage.objects) = 0, 'A cannot list B''s photos');
select pg_temp.expect_denied($$insert into public.items (user_id, id, category, color) values ('00000000-0000-0000-0000-00000000000b', 'x', 'top', 'red')$$, 'A writing into B''s wardrobe');
select pg_temp.expect_denied($$insert into storage.objects (bucket_id, name) values ('wardrobe', '00000000-0000-0000-0000-00000000000b/x.jpg')$$, 'A uploading into B''s photo folder');
insert into storage.objects (bucket_id, name) values ('wardrobe', '00000000-0000-0000-0000-00000000000a/a1.jpg');
select pg_temp.expect((select count(*) from storage.objects) = 1, 'A uploads into her own folder');
update public.items set status = 'laundry' where true;
set role service_role;
select pg_temp.expect((select status from public.items where id = 'b1') = 'available', 'A''s update did not touch B''s item');
set role authenticated;

-- Votes come only through the server.
select pg_temp.expect_denied($$insert into public.poll_votes values ('00000000-0000-0000-0000-00000000000b', 'p1', 'tok', 0)$$, 'voting from the app');

-- Support access: A grants 72 hours, cannot extend it, can revoke it.
select pg_temp.expect_denied($$insert into public.support_grants (user_id, item_ids, expires_at) values (auth.uid(), '{a1}', now() + interval '30 days')$$, 'a 30-day support grant');
insert into public.support_grants (user_id, item_ids) values (auth.uid(), '{a1}');
select pg_temp.expect_denied($$update public.support_grants set expires_at = now() + interval '10 days'$$, 'extending a grant');
select pg_temp.expect_denied($$update public.support_grants set item_ids = null$$, 'widening a grant to the whole wardrobe');
update public.support_grants set revoked_at = now();
select pg_temp.expect((select revoked_at is not null from public.support_grants), 'A revokes her grant');
select pg_temp.expect_denied($$insert into public.access_log (user_id, staff, item_ids) values (auth.uid(), 'me', '{a1}')$$, 'writing the access log from the app');

-- Demand signals: only while sharing is on, and gone when it is turned off.
select pg_temp.expect_denied($$insert into public.demand_signals (user_id, category, color) values (auth.uid(), 'shoes', 'white')$$, 'a signal without sharing on');
update public.profiles set share_demand = true;
insert into public.demand_signals (user_id, category, color) values (auth.uid(), 'shoes', 'white');
select pg_temp.expect_denied($$insert into public.demand_signals (user_id, category, color) values (auth.uid(), 'lingerie', 'black')$$, 'a lingerie signal');
select pg_temp.expect_denied($$insert into public.demand_signals (user_id, category, color) values ('00000000-0000-0000-0000-00000000000b', 'belt', 'black')$$, 'a signal for someone else');
update public.profiles set share_demand = false;
select pg_temp.expect((select count(*) from public.demand_signals) = 0, 'turning sharing off deletes the signals');
select pg_temp.expect_denied('select * from analytics.missing_pieces', 'users reading the analytics');
select pg_temp.expect_denied($$select * from public.support_open(1, 'me', '{a1}')$$, 'users calling the support tool');

-- The dashboard: nothing until a group has 50 users.
reset role;
insert into auth.users select ('00000000-0000-0000-0001-' || lpad(n::text, 12, '0'))::uuid from generate_series(1, 50) n;
set role service_role;
insert into public.profiles (id, share_demand)
  select ('00000000-0000-0000-0001-' || lpad(n::text, 12, '0'))::uuid, true from generate_series(1, 49) n;
insert into public.demand_signals (user_id, category, color)
  select ('00000000-0000-0000-0001-' || lpad(n::text, 12, '0'))::uuid, 'shoes', 'white' from generate_series(1, 20) n;
insert into public.wear_log (user_id, worn_at, item_ids, occasion)
  select ('00000000-0000-0000-0001-' || lpad(n::text, 12, '0'))::uuid, now(), '{x}', 'work' from generate_series(1, 49) n;
select pg_temp.expect((select count(*) from analytics.missing_pieces) = 0, '49 women: no missing pieces shown');
select pg_temp.expect((select count(*) from analytics.missing_colors) = 0, '49 women: no colours shown');
select pg_temp.expect((select count(*) from analytics.city_demand) = 0, '49 in Cairo: no city shown');
select pg_temp.expect((select count(*) from analytics.weekly) = 0, '49 active: no week shown');
insert into public.profiles (id, share_demand) values ('00000000-0000-0000-0001-000000000050', true);
insert into public.wear_log (user_id, worn_at, item_ids, occasion) values ('00000000-0000-0000-0001-000000000050', now(), '{x}', 'work');
select pg_temp.expect((select share_missing from analytics.missing_pieces where segment = 'women' and category = 'shoes') = 0.40, '50 women: 40% miss shoes');
select pg_temp.expect((select top_missing_color from analytics.city_demand where city = 'Cairo') = 'white', '50 in Cairo: white is the top missing colour');
select pg_temp.expect((select active_users from analytics.weekly) = 50, '50 active: the week is shown');

-- Support opens a wardrobe only through a live grant, and every opening is logged.
select pg_temp.expect_denied($$select * from public.support_open((select max(id) from public.support_grants), 'sara', '{a1}')$$, 'opening with a revoked grant');
set role authenticated;
insert into public.support_grants (user_id, item_ids) values (auth.uid(), '{a1}');
set role service_role;
select pg_temp.expect_denied($$select * from public.support_open((select max(id) from public.support_grants), 'sara', '{a1,a2}')$$, 'opening items outside the grant');
select pg_temp.expect((select count(*) from public.support_open((select max(id) from public.support_grants), 'sara', '{a1}')) = 1, 'support opens the granted item');
set role authenticated;
select pg_temp.expect((select staff from public.access_log) = 'sara', 'A sees who opened it');

-- Signed out: nothing.
reset role;
set role anon;
select pg_temp.expect_denied('select count(*) from public.items', 'anonymous reading items');

reset role;
\echo ALL RLS CHECKS PASSED
