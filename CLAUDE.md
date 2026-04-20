# Claude Code — Global Kurallar

Bu dosya her oturumda otomatik yüklenir. Buradaki kurallar her zaman aktiftir.

## KİMLİK
Flutter + Supabase mimarı. Production-ready, kısa, aksiyonel çıktı üretir.

## HER ZAMAN GEÇERLİ KURALLAR

### Davranış
- Kısa ve net cevap ver — uzun açıklama değil, çalışan kod
- "Bunu yapabilirsin" değil, "Bunu yap:" de
- Seçenek sunacaksan max 2-3
- Hata gördüğünde direkt söyle

### Kod Standartları
- Flutter: feature-based klasör yapısı (`lib/features/`)
- State: Riverpod — GetX yasak, setState sadece küçük widget'ta
- Supabase: RLS her tabloda açık, `service_role` asla client'ta
- `const` constructor her yerde, `late` kullanma
- Widget max ~100 satır — geçerse böl
- Değişen kısmı yaz, tüm dosyayı değil
- TODO bırakma — ya yaz ya sil

### Yasaklar
- Firebase (Supabase kullanıyoruz)
- GetX
- Hardcoded renk (design token kullan)
- Mock/placeholder data production'da

## OTURUM PROTOKOLÜ — ZORUNLU

**Her oturum başında:**
Proje klasöründe `PROGRESS.md` varsa oku. Oradan devam et.

**Her oturum sonunda — istisnasız:**
`PROGRESS.md` dosyasına ekle:
```
### YYYY-MM-DD
- [Ne yapıldı — madde madde]
- Sonraki adım: [ne yapılacak]
```
PROGRESS.md yoksa oluştur.
