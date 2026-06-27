create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create type public.user_role as enum ('gestor', 'repositor');
create type public.risk_zone as enum ('seguro', 'alerta', 'critico', 'vencido');
create type public.stock_event_type as enum (
  'entrada',
  'ajuste_manual',
  'saida_integracao',
  'acao_preventiva',
  'rotina_diaria'
);
create type public.notification_channel as enum ('push', 'whatsapp', 'email', 'multicanal');

create table if not exists public.stores (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  cnpj text not null unique,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.app_users (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique,
  store_id uuid not null references public.stores(id) on delete restrict,
  full_name text not null,
  email text not null unique,
  phone text,
  cpf text,
  role public.user_role not null default 'repositor',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  store_id uuid not null references public.stores(id) on delete cascade,
  ean13 text not null,
  description text not null,
  category text not null,
  sector text not null,
  unit_value numeric(12,2) not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (store_id, ean13)
);

create table if not exists public.product_batches (
  id uuid primary key default gen_random_uuid(),
  store_id uuid not null references public.stores(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  batch_code text not null,
  quantity_current integer not null check (quantity_current >= 0),
  unit_value numeric(12,2) not null default 0,
  expires_at date not null,
  risk_zone public.risk_zone not null default 'seguro',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  unique (store_id, product_id, batch_code)
);

create table if not exists public.expiration_alerts (
  id uuid primary key default gen_random_uuid(),
  store_id uuid not null references public.stores(id) on delete cascade,
  batch_id uuid not null references public.product_batches(id) on delete cascade,
  risk_zone public.risk_zone not null,
  title text not null,
  description text not null,
  notification_channel public.notification_channel not null default 'push',
  acknowledged_at timestamptz,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.stock_events (
  id uuid primary key default gen_random_uuid(),
  store_id uuid not null references public.stores(id) on delete cascade,
  batch_id uuid not null references public.product_batches(id) on delete cascade,
  user_id uuid references public.app_users(id) on delete set null,
  event_type public.stock_event_type not null,
  quantity_delta integer not null default 0,
  reason text not null,
  source text not null default 'app',
  financial_impact numeric(12,2) not null default 0,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.sales_webhook_events (
  id uuid primary key default gen_random_uuid(),
  store_id uuid not null references public.stores(id) on delete cascade,
  external_reference text,
  ean13 text not null,
  quantity_sold integer not null check (quantity_sold > 0),
  source_system text not null,
  payload jsonb not null default '{}'::jsonb,
  processed_at timestamptz,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists products_store_ean_idx
  on public.products (store_id, ean13);

create index if not exists product_batches_store_expiry_idx
  on public.product_batches (store_id, expires_at, risk_zone);

create index if not exists expiration_alerts_store_created_idx
  on public.expiration_alerts (store_id, created_at desc);

create index if not exists stock_events_store_created_idx
  on public.stock_events (store_id, created_at desc);

create index if not exists sales_webhook_events_store_created_idx
  on public.sales_webhook_events (store_id, created_at desc);

create or replace function public.refresh_risk_zone(expires_at date)
returns public.risk_zone
language plpgsql
as $$
declare
  remaining_days integer;
begin
  remaining_days := expires_at - current_date;
  if remaining_days < 0 then
    return 'vencido';
  elsif remaining_days <= 7 then
    return 'critico';
  elsif remaining_days <= 15 then
    return 'alerta';
  else
    return 'seguro';
  end if;
end;
$$;

create or replace function public.set_batch_risk_zone()
returns trigger
language plpgsql
as $$
begin
  new.risk_zone := public.refresh_risk_zone(new.expires_at);
  new.updated_at := timezone('utc', now());
  return new;
end;
$$;

drop trigger if exists stores_set_updated_at on public.stores;
create trigger stores_set_updated_at
before update on public.stores
for each row
execute procedure public.set_updated_at();

drop trigger if exists app_users_set_updated_at on public.app_users;
create trigger app_users_set_updated_at
before update on public.app_users
for each row
execute procedure public.set_updated_at();

drop trigger if exists products_set_updated_at on public.products;
create trigger products_set_updated_at
before update on public.products
for each row
execute procedure public.set_updated_at();

drop trigger if exists product_batches_set_risk_zone on public.product_batches;
create trigger product_batches_set_risk_zone
before insert or update on public.product_batches
for each row
execute procedure public.set_batch_risk_zone();

alter table public.stores enable row level security;
alter table public.app_users enable row level security;
alter table public.products enable row level security;
alter table public.product_batches enable row level security;
alter table public.expiration_alerts enable row level security;
alter table public.stock_events enable row level security;
alter table public.sales_webhook_events enable row level security;

drop policy if exists "Users can read their own store" on public.stores;
create policy "Users can read their own store"
on public.stores
for select
to authenticated
using (
  id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
);

drop policy if exists "Users can read own profile" on public.app_users;
create policy "Users can read own profile"
on public.app_users
for select
to authenticated
using (auth_user_id = auth.uid());

drop policy if exists "Users can manage store products" on public.products;
create policy "Users can manage store products"
on public.products
for all
to authenticated
using (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
)
with check (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
);

drop policy if exists "Users can manage store batches" on public.product_batches;
create policy "Users can manage store batches"
on public.product_batches
for all
to authenticated
using (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
)
with check (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
);

drop policy if exists "Users can manage store alerts" on public.expiration_alerts;
create policy "Users can manage store alerts"
on public.expiration_alerts
for all
to authenticated
using (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
)
with check (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
);

drop policy if exists "Users can manage store stock events" on public.stock_events;
create policy "Users can manage store stock events"
on public.stock_events
for all
to authenticated
using (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
)
with check (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
);

drop policy if exists "Users can manage store webhook events" on public.sales_webhook_events;
create policy "Users can manage store webhook events"
on public.sales_webhook_events
for all
to authenticated
using (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
)
with check (
  store_id in (
    select store_id
    from public.app_users
    where auth_user_id = auth.uid()
  )
);
