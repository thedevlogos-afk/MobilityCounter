-- Ejecuta este script en Supabase > SQL Editor

create table if not exists public.conteos_movilidad (
  id          bigint generated always as identity primary key,
  uid         uuid not null unique,                 -- id generado por el cliente (permite deshacer y evita duplicados)
  fecha       date not null,                        -- día de la captura
  cuadrante   text not null check (cuadrante in ('Poniente','Norte','Oriente','Sur')),
  punto       text not null check (punto ~ '^[PNOS][1-5]$'),
  categoria   text not null check (categoria in
              ('automovil','motocicleta','camion_urbano','camion_carga','peaton','bicicleta')),
  genero      text check (genero in ('hombre','mujer')),  -- solo aplica a peatones
  aforador    text,
  created_at  timestamptz not null default now(),   -- hora exacta del clic
  constraint genero_solo_peaton check ((categoria = 'peaton') = (genero is not null))
);

create index if not exists idx_conteos_fecha_punto on public.conteos_movilidad (fecha, punto);

alter table public.conteos_movilidad enable row level security;

-- Política básica (sin login): cualquiera con la anon key puede insertar, leer y deshacer.
-- Para producción: agrega Supabase Auth y limita estas políticas al rol "authenticated".
create policy "insertar" on public.conteos_movilidad for insert to anon, authenticated with check (true);
create policy "leer"     on public.conteos_movilidad for select to anon, authenticated using (true);
create policy "deshacer" on public.conteos_movilidad for delete to anon, authenticated using (true);

-- Vista lista para reportes y gráficas (Excel, Power BI, Metabase, etc.)
create or replace view public.resumen_conteos as
select fecha, cuadrante, punto, categoria, genero,
       date_trunc('hour', created_at) as hora,
       count(*) as total
from public.conteos_movilidad
group by 1,2,3,4,5,6;
