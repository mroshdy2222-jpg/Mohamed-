#!/bin/sh
# Runs the migration on a throwaway local Postgres and checks the access rules.
set -e
here=$(cd "$(dirname "$0")" && pwd)
bin=$(ls -d /usr/lib/postgresql/*/bin | tail -1)
runner=pgtest
id "$runner" >/dev/null 2>&1 || useradd -M -s /bin/sh "$runner"
dir=$(mktemp -d) && chown "$runner" "$dir"
cp "$here"/*.sql "$here/../../supabase/migrations/"*.sql "$dir"/ && chown "$runner" "$dir"/*.sql
su "$runner" -c "$bin/initdb -D $dir/data -U postgres -A trust >/dev/null && $bin/pg_ctl -D $dir/data -o '-p 5499 -k $dir' -l $dir/log start >/dev/null"
trap 'su "$runner" -c "$bin/pg_ctl -D $dir/data stop -m fast >/dev/null"; rm -rf "$dir"' EXIT
psql="$bin/psql -h $dir -p 5499 -U postgres -q -v ON_ERROR_STOP=1"
$psql -c 'create database talla' >/dev/null
$psql -d talla -f "$dir/supabase_stub.sql" >/dev/null
for m in "$dir"/2*.sql; do $psql -d talla -f "$m" >/dev/null; done
status=0
$psql -d talla -t -A -f "$dir/rls_test.sql" >"$dir/out" 2>&1 || status=$?
sed -n "s/^psql:[^ ]* NOTICE:  //p; s/^psql:[^ ]* ERROR:  /ERROR: /p; /ALL RLS/p" "$dir/out"
exit $status
