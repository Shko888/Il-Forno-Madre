-- ============================================================
-- SCHEMA DATABASE — Il Forno Madre B2B Platform
-- Versione: 1.0 | Data: 2025-05-10
-- Esegui nell'SQL Editor di Supabase → Run
-- ============================================================

-- ── PRODOTTI ────────────────────────────────────────────────
create table if not exists products (
  id          text primary key,
  emoji       text not null default '🍞',
  name        text not null,
  cat         text not null default 'Altro',
  description text,
  weight      text,
  price       numeric(10,2) not null check (price >= 0),
  unit        text not null default 'pz',
  min_ord     integer not null default 1 check (min_ord >= 1),
  tags        text[] not null default '{}',
  badge       text not null default '',
  active      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ── CLIENTI ─────────────────────────────────────────────────
create table if not exists clients (
  id          text primary key,
  name        text not null,
  type        text,
  contact     text,
  tel         text,
  email       text,
  addr        text,
  piva        text,
  agent_id    text,
  listino     text not null default 'A' check (listino in ('A','B','C')),
  note        text,
  active      boolean not null default true,
  created_at  timestamptz not null default now()
);

-- ── AGENTI ──────────────────────────────────────────────────
create table if not exists agents (
  id          text primary key,
  name        text not null,
  tel         text,
  email       text,
  piva        text,
  zona        text,
  contract    text,
  provv       numeric(5,2) not null default 6.00 check (provv >= 0 and provv <= 100),
  bonus_new   numeric(8,2) not null default 50.00,
  bonus_fid   numeric(8,2) not null default 30.00,
  note        text,
  active      boolean not null default true,
  client_ids  text[] not null default '{}',
  created_at  timestamptz not null default now()
);

-- ── ORDINI ──────────────────────────────────────────────────
create table if not exists orders (
  id              text primary key,
  client_name     text not null,
  client_id       text references clients(id) on delete set null,
  tel             text,
  addr            text,
  agent_name      text,
  order_date      date not null default current_date,
  delivery_date   date,
  delivery_time   text,
  items           jsonb not null default '[]',
  note            text,
  status          text not null default 'new'
                  check (status in ('new','confirmed','production','delivered','cancelled')),
  total           numeric(10,2) check (total >= 0),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- ── OFFERTE ─────────────────────────────────────────────────
create table if not exists offers (
  id              text primary key,
  emoji           text not null default '🏷',
  name            text not null,
  type            text check (type in ('pct','fixed','bundle','free_delivery')),
  value           numeric(10,2),
  description     text,
  prod_id         text not null default 'all',
  valid_from      date,
  valid_to        date,
  clients_target  text not null default 'all',
  active          boolean not null default true,
  created_at      timestamptz not null default now()
);

-- ── INDICI ──────────────────────────────────────────────────
create index if not exists idx_products_active on products(active);
create index if not exists idx_products_cat on products(cat);
create index if not exists idx_orders_status on orders(status);
create index if not exists idx_orders_delivery_date on orders(delivery_date);
create index if not exists idx_orders_client_name on orders(client_name);
create index if not exists idx_clients_active on clients(active);
create index if not exists idx_agents_active on agents(active);

-- ── TRIGGER updated_at ──────────────────────────────────────
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_products_updated_at
  before update on products
  for each row execute function update_updated_at();

create trigger trg_orders_updated_at
  before update on orders
  for each row execute function update_updated_at();

-- ── REALTIME ────────────────────────────────────────────────
alter table orders replica identity full;
alter publication supabase_realtime add table orders;

-- ── ROW LEVEL SECURITY ──────────────────────────────────────
-- (policy aperta per fase di lancio — restringere in produzione)

alter table products enable row level security;
alter table clients  enable row level security;
alter table agents   enable row level security;
alter table orders   enable row level security;
alter table offers   enable row level security;

-- Products: lettura pubblica (menu B2B), scrittura solo autenticati
create policy "public_read_products"
  on products for select using (true);

create policy "admin_write_products"
  on products for all using (true)
  with check (true);

-- Orders: chiunque può inserire (cliente B2B), admin può fare tutto
create policy "public_insert_orders"
  on orders for insert with check (true);

create policy "admin_all_orders"
  on orders for all using (true);

-- Clients, agents, offers: admin only (lettura+scrittura)
create policy "admin_all_clients"
  on clients for all using (true);

create policy "admin_all_agents"
  on agents for all using (true);

create policy "admin_all_offers"
  on offers for all using (true);

-- ── DATI INIZIALI — PRODOTTI ─────────────────────────────────
insert into products
  (id, emoji, name, cat, description, weight, price, unit, min_ord, tags, badge, active)
values
  (
    'teg_b', '🟨', 'Focaccia Bianca', 'Teglie',
    'Teglia 60×40 · impasto artigianale alta idratazione · olio EVO · abbattuta surgelata',
    '1.315 kg finito', 10.00, 'teglia', 1,
    array['vegano','surgelato'], '', true
  ),
  (
    'teg_r', '🍕', 'Pizza Rossa (teglia)', 'Teglie',
    'Teglia 60×40 · salsa pomodoro biologica · impasto diretto 24h · abbattuta surgelata',
    '1.470 kg finito', 13.00, 'teglia', 1,
    array['surgelato'], '', true
  ),
  (
    'focc_b', '🤍', 'Focaccina Bianca', 'Focaccine',
    '50g · olio EVO · sale grosso · in sacchetto da 50 pz · abbattuta surgelata',
    '~50g cad.', 0.28, 'pz', 50,
    array['vegano','surgelato'], '', true
  ),
  (
    'focc_r', '🍅', 'Focaccina Rossa', 'Focaccine',
    '57g · salsa pomodoro · olio EVO · in sacchetto da 50 pz · abbattuta surgelata',
    '~57g cad.', 0.60, 'pz', 50,
    array['vegano','surgelato'], '', true
  ),
  (
    'hamburger', '🍔', 'Panino Hamburger', 'Panini',
    '75g · impasto soffice artigianale · sottovuoto in buste da 3 pz · surgelato',
    '75g finito', 1.10, 'pz', 9,
    array['surgelato'], '', true
  ),
  (
    'piz_rot', '⚪', 'Pizza Rotonda Bianca', 'Pizze',
    'Ø 33cm · 200g · precotta · sottovuoto · ideale per completamento con ingredienti freschi',
    '200g', 3.20, 'pz', 5,
    array['surgelato','sottovuoto'], '', true
  )
on conflict (id) do update set
  price       = excluded.price,
  description = excluded.description,
  active      = excluded.active,
  updated_at  = now();

-- ── VERIFICA FINALE ──────────────────────────────────────────
-- Esegui queste query per verificare che tutto sia ok:
-- select count(*) from products;        -- deve restituire 6
-- select count(*) from orders;          -- 0 (nessun ordine iniziale)
-- select tablename from pg_tables where schemaname = 'public';
