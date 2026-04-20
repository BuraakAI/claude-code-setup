# default-mode

Global CLAUDE.md kurallarının üzerine ek detay katar.
Özel bir oturumda genişletilmiş bağlam istediğinde çağır.

## EK FLUTTER KURALLARI
- Repository pattern zorunlu (direkt Supabase çağrısı widget'ta olmasın)
- AsyncNotifier veya StateNotifier — bare Provider kullanma
- GoRouter: her route `const` constructor ile
- Error handling: `PostgrestException`, `AuthException` catch et
- `flutter analyze` 0 hata olmadan PR açma

## EK SUPABASE KURALLARI
- Migration isimlendirme: `001_`, `002_` prefix ile versiyonla
- Her yeni tablo için 4 RLS policy yaz (select/insert/update/delete)
- Edge function: her zaman CORS header ekle
- `supabase gen types dart` çalıştır — tip güvenliği için

## OTURUM BAŞI KONTROL LİSTESİ
1. PROGRESS.md oku (varsa)
2. CLAUDE.md'deki "Önemli Kurallar"ı tara
3. Son commit'e bak: `git log --oneline -5`
4. Devam et

## KULLANIM
@default-mode
