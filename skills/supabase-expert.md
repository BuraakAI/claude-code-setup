# supabase-expert

Supabase konularında bu standartları uygula.

## SCHEMA TASARIMI
- Her tablo `id uuid primary key default gen_random_uuid()`
- `created_at timestamptz default now()` her tabloda
- `user_id uuid references auth.users(id) on delete cascade` — user'a bağlı veride
- Foreign key'ler her zaman explicit
- Index: sık sorgulanan kolonlara (user_id, created_at)

## RLS (Row Level Security)
Her tablo için şablon:
```sql
alter table {table} enable row level security;

-- Kullanıcı kendi verisini görür
create policy "select_own" on {table}
  for select using (auth.uid() = user_id);

-- Kullanıcı kendi verisini ekler
create policy "insert_own" on {table}
  for insert with check (auth.uid() = user_id);

-- Kullanıcı kendi verisini günceller
create policy "update_own" on {table}
  for update using (auth.uid() = user_id);

-- Kullanıcı kendi verisini siler
create policy "delete_own" on {table}
  for delete using (auth.uid() = user_id);
```

## MİGRASYON AKIŞI
```bash
supabase migration new {açıklama}    # Yeni migration
supabase db push                      # Prod'a uygula
supabase db pull                      # Remote şemayı çek
supabase db reset                     # Local sıfırla (test)
```

## FLUTTER ENTEGRASYONU
```dart
// Singleton erişim
final supabase = Supabase.instance.client;

// Güvenli sorgu pattern'i
Future<List<T>> fetchItems() async {
  final data = await supabase
    .from('table')
    .select()
    .eq('user_id', supabase.auth.currentUser!.id);
  return data.map((e) => T.fromJson(e)).toList();
}
```

## GÜVENLİK KURALLARI
- `anon` key: sadece public işlemler
- `service_role` key: asla Flutter app'te, sadece server/CI
- Auth session: `supabase.auth.onAuthStateChange` dinle
- Token yenileme: SDK otomatik yapar, müdahale etme

## EDGE FUNCTIONS
- Deno runtime, TypeScript
- `supabase functions new {name}` ile oluştur
- CORS header zorunlu (Flutter Web için)
- Secrets: `supabase secrets set KEY=value`
