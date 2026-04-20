# new-project

Kullanım: `@new-project {proje-adı} {kısa açıklama}`

Yeni Flutter + Supabase projesi başlatmak için scaffold üretir.

## ÜRETECEKLERIM

### 1. pubspec.yaml bağımlılıkları
```yaml
dependencies:
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x
  supabase_flutter: ^2.x
  go_router: ^14.x
  freezed_annotation: ^2.x
  json_annotation: ^4.x

dev_dependencies:
  build_runner: ^2.x
  freezed: ^2.x
  json_serializable: ^6.x
  riverpod_generator: ^2.x
```

### 2. Klasör yapısı
```
lib/
  core/
    constants/    # app_constants.dart, supabase_constants.dart
    errors/       # app_exception.dart
    router/       # app_router.dart (GoRouter)
    theme/        # app_theme.dart
  features/
    auth/         # Giriş, kayıt, profil
    {feature}/    # Proje özelliklerine göre
  shared/
    widgets/      # Ortak widget'lar
    utils/        # Yardımcı fonksiyonlar
```

### 3. main.dart (Supabase + Riverpod init)
### 4. Supabase schema (profiles tablosu + RLS)
### 5. Auth feature (email+şifre)
### 6. GoRouter yapısı
### 7. CLAUDE.md (proje bağlamı)

## NOTLAR
- `.env` dosyası için `flutter_dotenv` ekle
- `SUPABASE_URL` ve `SUPABASE_ANON_KEY` env'den oku
- Platform: iOS + Android varsayılan, web istersen belirt
