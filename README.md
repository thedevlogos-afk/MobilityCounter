# Sistema Básico de Conteo de Movilidad

Frontend estático (HTML + JS) + Supabase (base de datos) + Vercel (hosting).

## Estructura
```
index.html            # app completa
supabase/schema.sql   # tabla, políticas RLS y vista de resumen
```

## Puesta en marcha
1. **Supabase**: crea un proyecto → *SQL Editor* → pega y ejecuta `supabase/schema.sql`.
2. En *Project Settings → API* copia la **Project URL** y la **anon public key**.
3. En `index.html` reemplaza `SUPABASE_URL` y `SUPABASE_ANON_KEY`.
4. **GitHub**: crea el repo y sube estos archivos.
   ```bash
   git init && git add . && git commit -m "Conteo de movilidad"
   git branch -M main
   git remote add origin https://github.com/TU_USUARIO/conteo-movilidad.git
   git push -u origin main
   ```
5. **Vercel**: *Add New → Project* → importa el repo → Framework Preset: *Other* → Deploy.
   Cada `git push` redepliega automáticamente.

## Uso
Elegir cuadrante → punto (P1–P5, N1–N5, O1–O5, S1–S5) → día de captura → **Iniciar conteo**.
Cada toque registra una fila con fecha, punto, categoría y hora exacta. Si no hay red, se guarda localmente y se sincroniza solo.
**Exportar** descarga `.xlsx` (hojas *Registros* y *Resumen*) o `.csv` por rango de fechas.

## Seguridad
Las políticas incluidas son abiertas (sin login) para empezar rápido. Antes de uso real, activa Supabase Auth y cambia `anon` por `authenticated` en las políticas.
