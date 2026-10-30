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

-- Signed out: nothing.
reset role;
set role anon;
select pg_temp.expect_denied('select count(*) from public.items', 'anonymous reading items');

reset role;
\echo ALL RLS CHECKS PASSED
