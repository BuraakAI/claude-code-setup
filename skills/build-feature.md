# build-feature

Kullanım: `@build-feature {özellik-adı} {açıklama}`

Örnek: `@build-feature auth "email+şifre ile giriş ve kayıt"`

## NE YAPARSIM

Verilen özellik için tam, çalışır kod üretirim:

1. **Klasör yapısı** oluştur: `lib/features/{özellik}/`
   - `data/` → repository, data source, model
   - `domain/` → entity, use case (gerekirse)
   - `presentation/` → screen, widget, provider/bloc

2. **Supabase entegrasyonu** varsa:
   - Repository sınıfı (Supabase client inject)
   - RLS-uyumlu sorgular
   - Error handling (PostgrestException)

3. **Routing**: GoRouter entegrasyonu

4. **Riverpod provider** veya Bloc:
   - AsyncNotifier veya StateNotifier
   - Loading/error/data state

## ÇIKTI FORMATI
Her dosyayı ayrı kod bloğu olarak, dosya yoluyla birlikte ver:
```dart
// lib/features/auth/data/auth_repository.dart
...
```

## NOTLAR
- Test yazmam (istenirse yaz deyin)
- Tüm import'lar eksiksiz
- Null safety zorunlu
- Magic string yok → const class'a taşı
