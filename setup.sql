-- Sponsorenlauf Rundenzähler – Tabellen (Präfix slauf_), im Projekt «praxisna» bereits eingerichtet.
-- Für ein anderes Projekt: einmal im Supabase SQL-Editor ausführen (New query › Run).

create table if not exists public.slauf_players (
  id      text primary key,
  name    text not null check (char_length(name) between 1 and 60),
  nr      text not null default '' check (char_length(nr) <= 4),
  created bigint
);

create table if not exists public.slauf_laps (
  id        text primary key,
  player_id text not null references public.slauf_players(id) on delete cascade,
  bonus     int  not null default 0 check (bonus in (0, 30, 60, 90, 180)),
  t         bigint not null,
  device    text
);
create index if not exists slauf_laps_player_idx on public.slauf_laps(player_id);

create table if not exists public.slauf_config (
  id         text primary key,
  lap_meters int not null default 180 check (lap_meters between 1 and 2000)
);
insert into public.slauf_config (id, lap_meters) values ('main', 180) on conflict (id) do nothing;

-- Zugriff für die Web-App (anon Key). Jede Person mit dem App-Link kann lesen und erfassen.
alter table public.slauf_players enable row level security;
alter table public.slauf_laps    enable row level security;
alter table public.slauf_config  enable row level security;

drop policy if exists "slauf app access" on public.slauf_players;
drop policy if exists "slauf app access" on public.slauf_laps;
drop policy if exists "slauf app access" on public.slauf_config;
create policy "slauf app access" on public.slauf_players for all to anon, authenticated using (true) with check (true);
create policy "slauf app access" on public.slauf_laps    for all to anon, authenticated using (true) with check (true);
create policy "slauf app access" on public.slauf_config  for all to anon, authenticated using (true) with check (true);

grant select, insert, update, delete on public.slauf_players, public.slauf_laps, public.slauf_config to anon, authenticated;

-- Live-Aktualisierung auf allen Geräten
do $$
begin
  begin alter publication supabase_realtime add table public.slauf_players; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.slauf_laps;    exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.slauf_config;  exception when duplicate_object then null; end;
end $$;

-- Nach dem Lauf alles löschen (bei Bedarf einzeln ausführen):
-- delete from public.slauf_laps; delete from public.slauf_players;
