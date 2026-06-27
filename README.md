# BIPSTOCK Flutter

Migracao do app BIPSTOCK para Flutter com backend em Supabase.

## Rodando o app

```bash
flutter pub get
flutter run --dart-define=SUPABASE_URL=https://srfuqdamnbkmnlwggzvf.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=seu_publishable_key
```

O app tambem possui fallback para os valores que ja estavam em `.env`, mas `--dart-define` continua sendo o caminho mais limpo para build e CI.

## Estrutura Supabase

Ja existe uma migration pronta em `supabase/migrations/20260625164000_create_plugselo_tables.sql` com:

- `stamp_wallets`
- `stamp_transactions`
- politicas RLS abertas para `anon` e `authenticated` no modo prototipo

## CLI do Supabase

O diretorio `supabase/` ja estava inicializado. Para vincular este projeto ao projeto remoto, use:

```bash
supabase login
supabase link --project-ref srfuqdamnbkmnlwggzvf
supabase db push
```

Se a CLI pedir a senha do banco, informe a senha real do Postgres do projeto. O valor `postgresql://postgres:[YOUR-PASSWORD]@db.srfuqdamnbkmnlwggzvf.supabase.co:5432/postgres` que voce enviou ainda esta com placeholder e por isso nao da para concluir o link automaticamente daqui.

