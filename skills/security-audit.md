# security-audit

Flutter + Supabase + IAP + RevenueCat projelerinde güvenlik açığı tara.

Kullanım: `@security-audit` (kod yapıştır veya "projeyi tara" de)

---

## 1. FLUTTER — GENEL

### Hardcoded Secret Tara
```
grep -r "supabase\|apiKey\|secret\|password\|token\|key" lib/ --include="*.dart" -i
```
- API key, token, URL doğrudan kodda olmamalı
- `.env` veya `--dart-define` kullan
- `flutter_dotenv` ile env oku

### Release Build Kontrolleri
- `kDebugMode` korumasız `print()` / `debugPrint()` → log sızıntısı
- `assert()` production'da çalışmaz — güvenlik kontrolü için kullanma
- ProGuard / R8 aktif mi? (`android/app/build.gradle.kts` → `minifyEnabled true`)
- iOS: `NSLog` release'de çıktı verir — kaldır

### Obfuscation (Android/iOS)
```gradle
// android/app/build.gradle.kts
buildTypes {
    release {
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
    }
}
```
```bash
# Flutter obfuscation
flutter build apk --obfuscate --split-debug-info=build/debug-info
```

---

## 2. SUPABASE GÜVENLİK

### RLS Kapsamı — Tüm Tabloları Kontrol Et
```sql
-- RLS açık olmayan tabloları bul
SELECT tablename FROM pg_tables
WHERE schemaname = 'public'
AND tablename NOT IN (
  SELECT DISTINCT tablename FROM pg_policies
);
```
Her tabloda en az SELECT policy olmalı.

### Service Role Key Tara
```
grep -r "service_role\|eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9" lib/ --include="*.dart"
```
`service_role` key Flutter app'te KESİNLİKLE olmamalı.

### Edge Function Auth Kontrolü
Her edge function başında:
```typescript
const authHeader = req.headers.get('Authorization')
if (!authHeader) return new Response('Unauthorized', { status: 401 })
const token = authHeader.replace('Bearer ', '')
const { data: { user }, error } = await supabase.auth.getUser(token)
if (error || !user) return new Response('Unauthorized', { status: 401 })
```

### Webhook Doğrulama (RevenueCat / Stripe)
```typescript
// revenuecat-webhook edge function
const authKey = Deno.env.get('REVENUECAT_WEBHOOK_AUTH_KEY')
const incoming = req.headers.get('Authorization')
if (incoming !== authKey) return new Response('Forbidden', { status: 403 })
```
Webhook auth key eksikse → herkes webhook gönderebilir → sahte premium!

### Storage Bucket Güvenliği
```sql
-- Public bucket var mı kontrol et
SELECT name, public FROM storage.buckets;
```
`headshots` gibi kullanıcı verisi içeren bucket public OLMAMALI.
RLS policy ekle:
```sql
create policy "Kullanici kendi dosyasini gorur"
on storage.objects for select
using (auth.uid()::text = (storage.foldername(name))[1]);
```

---

## 3. IAP GÜVENLİĞİ (in_app_purchase)

### Client-Side Doğrulama — YAPMA
```dart
// YANLIŞ — client'a güvenme
if (purchaseDetails.status == PurchaseStatus.purchased) {
  grantPremium(); // ← manipüle edilebilir
}
```

### Server-Side Doğrulama — YAP
```dart
// DOĞRU
if (purchaseDetails.status == PurchaseStatus.purchased) {
  final verified = await verifyReceiptOnServer(
    purchaseDetails.verificationData.serverVerificationData
  );
  if (verified) grantPremium();
}
```
Receipt Supabase Edge Function veya kendi backend'inde doğrulanmalı.

### Receipt Validation Edge Function (temel)
```typescript
// Google Play
const response = await fetch(
  `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/products/${productId}/tokens/${purchaseToken}`,
  { headers: { Authorization: `Bearer ${accessToken}` } }
)
const data = await response.json()
if (data.purchaseState !== 0) throw new Error('Invalid purchase')
```

---

## 4. REVENUECAT GÜVENLİĞİ

### Entitlement Server-Side Kontrol
```dart
// Client'ta RC CustomerInfo'ya güvenmek YANLIŞ
// Premium işlemler için Supabase'den doğrula:
final isPremium = await supabase
  .from('profiles')
  .select('is_premium')
  .eq('id', userId)
  .single();
```
`revenuecat-webhook` → Supabase'i günceller → app Supabase'den okur.

### Webhook İmzası
RC Dashboard → Webhooks → Authorization Header ayarla.
`REVENUECAT_WEBHOOK_AUTH_KEY` Supabase secret'ta olmalı, kodda asla.

### API Key Exposure
```
grep -r "appl_\|goog_" lib/ --include="*.dart"
```
RC public key (appl_/goog_) kodda olabilir ama `service_role` ile karıştırma.

---

## 5. NETWORK GÜVENLİĞİ

### HTTPS Zorla (Android)
`android/app/src/main/res/xml/network_security_config.xml`:
```xml
<network-security-config>
    <base-config cleartextTrafficPermitted="false" />
</network-security-config>
```

### iOS ATS
`ios/Runner/Info.plist`'te `NSAllowsArbitraryLoads` → `false` olmalı.

---

## 6. VERİ DEPOLAMA

### Hassas Veri — SharedPreferences KULLANMA
```dart
// YANLIŞ — şifrelenmemiş
SharedPreferences.setString('token', userToken);

// DOĞRU — Keychain/Keystore
flutter_secure_storage: ^9.x
await secureStorage.write(key: 'token', value: userToken);
```
JWT, refresh token, kullanıcı kimlik bilgileri `flutter_secure_storage` ile sakla.

---

## ÇIKTI FORMATI

Tarama sonunda şu formatta raporla:
```
KRITIK  : [açıklama] → [dosya:satır] → [fix]
ORTA    : [açıklama] → [dosya:satır] → [fix]
DÜŞÜK   : [açıklama] → [öneri]
TEMIZ   : [kontrol edilen alan]
```
