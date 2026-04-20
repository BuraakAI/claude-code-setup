# Claude Code — Tam Sistem Rehberi

> Güncelleme: 2026-04-19 (v2)

---

## Sisteme Genel Bakış

Bu sistem 2026-04-19 kuruldu.

- 1 global `CLAUDE.md` (her oturumda otomatik aktif)
- 9 global skill (`@` ile çağrılır)
- 2 MCP sunucusu (Excalidraw + Supabase)
- 1 otomatik hook (oturum log — smart-commit kaldırıldı)
- 2 aktif proje (AI Headshot + Blokku)
- GitHub: [github.com/BuraakAI/claude-code-setup](https://github.com/BuraakAI/claude-code-setup)

---

## A) Global CLAUDE.md — Otomatik Aktif Kurallar

**Dosya:** `~/.claude/CLAUDE.md`

Bu dosya her oturumda Claude tarafından otomatik okunur. Hiçbir şey yazmana gerek yok — her zaman aktif.

**İçeriği:**
- Flutter/Supabase kod standartları
- Yasaklar (Firebase, GetX, hardcode renk...)
- Oturum protokolü (PROGRESS.md okuma/yazma zorunluluğu)

**Nasıl çalışır (log sistemi):**

1. Oturum başında: Claude `PROGRESS.md`'yi okur (varsa)
2. İş yapılır
3. Oturum sonunda:
   - Claude, `PROGRESS.md`'ye ne yapıldığını yazar (CLAUDE.md zorlar)
   - Stop hook (`log-session.ps1`) timestamp ekler: `--- Oturum kapandı: 2026-04-19 16:45 ---`

**Sonuç:** `PROGRESS.md` hem içerik hem zaman damgası alır.

---

## B) Global Skill'ler (`~/.claude/skills/`)

Skills `@` ile **elle** çağrılır — otomatik aktif **değil**.
(Otomatik aktif olan = `~/.claude/CLAUDE.md` — bkz. A bölümü)

| Skill | Açıklama & Kullanım |
|---|---|
| `@default-mode` | Global CLAUDE.md'yi tamamlar. Ek Flutter kuralları, repository pattern, tip güvenliği. Detaylı oturum için çağır. |
| `@token-saver` | Kısa mod. Token israfını keser. |
| `@build-feature` | Yeni özellik için tam scaffold üretir. Kullanım: `@build-feature auth "email ile giriş"` — Çıktı: feature klasörü + repo + provider + route |
| `@bug-hunter` | Root cause analizi. Stack trace yapıştır. Çıktı: HATA / NEDEN / FİX formatında |
| `@supabase-expert` | Schema tasarımı, RLS policy, migration akışı, Flutter entegrasyon pattern'leri. |
| `@new-project` | Sıfırdan Flutter+Supabase proje iskeleti. Kullanım: `@new-project uygulama-adı "açıklama"` |
| `@seo-optimizer` | Web SEO, Core Web Vitals, keyword, schema markup |
| `@excalidraw-skill` | Diyagram ve roadmap çizimi (MCP gerekli). |
| `@security-audit` | Flutter+Supabase+IAP+RevenueCat güvenlik taraması. Hardcoded key, RLS boşluğu, webhook auth, IAP server-side doğrulama, obfuscation kontrol. Çıktı: KRİTİK / ORTA / DÜŞÜK / TEMİZ raporu |

**Kombinasyonlar:**

```
@token-saver @bug-hunter        → kısa hata analizi
@supabase-expert @build-feature → Supabase entegrasyonlu feature
```

---

## C) MCP Sunucuları

### 1. Excalidraw MCP (Global — tüm projelerde)

- **Kapsam:** Global (`~/.claude.json`)
- **Sunucu:** `C:\Users\burak\tools\mcp_excalidraw\dist\index.js`
- **26 araç:** element CRUD, hizalama, gruplama, screenshot, snapshot, Mermaid→Excalidraw, export/import

**Kullanım:**

```bash
# Adım 1 — Canvas server'ı başlat (ayrı terminal, açık bırak)
cd C:\Users\burak\tools\mcp_excalidraw
npm run canvas
```

Adım 2 — Tarayıcıda aç: `http://localhost:3000`

Adım 3 — Claude'a söyle:
```
@excalidraw-skill [proje adı] için ekran akışı çiz
```

### 2. Supabase MCP (ai_headshot_app — proje bazlı)

- **Kapsam:** Sadece `ai_headshot_app` klasörü
- **Dosya:** `ai_headshot_app/.mcp.json` ← `.gitignore`'da, commit edilmez
- **Proje:** `iyixiqphiczsciscwejw`

Aktivasyon: `ai_headshot_app` klasöründe `claude` açılınca otomatik.

**Ne yapabilirsin:**
- Tabloları sorgula / yaz / sil
- Schema incele, tablo listele
- Migration yaz ve uygula
- RLS policy test et

**Örnek:**
```
"headshots tablosunu göster"
"RLS policy doğru mu kontrol et"
"profiles tablosuna bio kolonu ekle"
```

---

## D) Otomatik Hook (`~/.claude/settings.json`)

> **Not:** SMART-COMMIT kaldırıldı — yarım commit, bozuk git geçmişi riski. Git commit'leri manuel yapılır veya proje bazlı eklenir.

### Stop Hook — Oturum Log Timestamp'i

- **Ne zaman:** Claude her oturumu bitirdiğinde (otomatik)
- **Ne yapar:** `PROGRESS.md` varsa `--- Oturum kapandı: tarih ---` ekler
- **Script:** `C:\Users\burak\.claude\scripts\log-session.ps1`

`PROGRESS.md` içeriğini Claude yazar (CLAUDE.md protokolü), timestamp'i stop hook ekler. İkisi birlikte tam log oluşturur.

---

## E) Aktif Projeler

### AI Headshot App

| | |
|---|---|
| Konum | `C:\Users\burak\OneDrive\Desktop\ai_headshot_app\` |
| Durum | Yayına hazırlanma aşaması |
| Stack | Flutter + Supabase + fal.ai + RevenueCat |
| MCP | Supabase bağlı (otomatik aktif) |

**Yayın için kalan:**
- [ ] RevenueCat (atelier_pro_monthly/annual)
- [ ] Google Sign-In (Firebase Console)
- [ ] Apple Sign-In (Apple Developer)
- [ ] App Store Connect + Google Play internal test
- [ ] TestFlight build

### Blokku Block Puzzle

| | |
|---|---|
| Konum | `C:\Users\burak\.gemini\antigravity\scratch\woodblock\` |
| Durum | Yayına hazır — sadece IAP ürünleri bekleniyor |
| Stack | Flutter + Firebase + google_mobile_ads |
| Versiyon | 1.3.0+25 |

**Kalan:**
- [ ] Play Store + App Store: 3 IAP ürün (candy/tropical/lavender)
- [ ] Sandbox IAP testi → build → gönderim

---

## F) Yeni Proje Başlatma Akışı

**1. Roadmap** (koddan ÖNCE)
```bash
cd C:\Users\burak\tools\mcp_excalidraw && npm run canvas
# http://localhost:3000
# "@excalidraw-skill [ad] için ekran akışı çiz"
```

**2. CLAUDE.md oluştur**
```
Kopyala: C:\Users\burak\.claude\templates\CLAUDE.md
Doldur: proje adı, stack, tablolar, kararlar
```

**3. İskelet**
```
@new-project uygulama-adi "kısa açıklama"
```

**4. Supabase bağla**
```bash
supabase link --project-ref <ref>
supabase db pull
```

**5. `.mcp.json` ekle** (proje köküne, `.gitignore`'a da ekle!)
```
Şablon: C:\Users\burak\.claude\templates\mcp-supabase-example.json
Token : https://supabase.com/dashboard/account/tokens
```

---

## G) Günlük Geliştirme Akışı

| Görev | Komut |
|---|---|
| Yeni özellik | `@build-feature <özellik> "<açıklama>"` |
| Hata | `@bug-hunter` → stack trace yapıştır |
| Supabase | `ai_headshot_app`'te direkt yaz, MCP halleder |
| Kod inceleme | `git diff origin/main...HEAD \| claude -p "Sorun var mı?"` |
| Token tasarrufu | `@token-saver` |

---

## H) Supabase CLI (Hızlı Referans)

```bash
supabase login
supabase link --project-ref <ref>
supabase db pull / push / reset
supabase migration new <açıklama>
supabase functions new/deploy <ad>
supabase secrets set KEY=value
```

**CLI:** `C:\Users\burak\AppData\Local\supabase\supabase.exe`

---

## I) Dosya Haritası

```
~/.claude/
├── CLAUDE.md              ← OTOMATIK AKTİF (her oturumda yüklenir)
├── settings.json          ← Stop hook
├── skills/
│   ├── default-mode.md    → @default-mode (elle çağır)
│   ├── token-saver.md     → @token-saver
│   ├── build-feature.md   → @build-feature
│   ├── bug-hunter.md      → @bug-hunter
│   ├── supabase-expert.md → @supabase-expert
│   ├── new-project.md     → @new-project
│   ├── seo-optimizer/     → @seo-optimizer
│   ├── excalidraw-skill/  → @excalidraw-skill
│   └── security-audit.md  → @security-audit
└── scripts/
    └── log-session.ps1    → Stop hook (timestamp)

~/.claude.json             → Excalidraw MCP kaydı (global)

Projeler:
  ai_headshot_app/
    .mcp.json              → Supabase MCP (.gitignore'da)
    CLAUDE.md / PROGRESS.md
  woodblock/ (Blokku)
    CLAUDE.md / PROGRESS.md

Tools:
  C:\Users\burak\tools\mcp_excalidraw\  → Excalidraw MCP
```

---

## J) GitHub Backup & Ekip Kurulumu

- **Repo:** [github.com/BuraakAI/claude-code-setup](https://github.com/BuraakAI/claude-code-setup)
- **Güncelle:** `claude-code-setup` klasöründe değişiklik yap → commit → push

**Ekip üyesi kurulumu:**
```powershell
# Windows
irm https://raw.githubusercontent.com/BuraakAI/claude-code-setup/main/install.ps1 | iex

# Mac/Linux
curl -fsSL https://raw.githubusercontent.com/BuraakAI/claude-code-setup/main/install.sh | bash
```

Sistem güncellemesi geldiğinde aynı komutu tekrar çalıştır — mevcut ayarları silmez, merge eder.

---

## K) Hatırlatıcılar

- `~/.claude/CLAUDE.md` her oturumda otomatik — skills değil
- Skills `@` ile **elle** çağrılır
- `.mcp.json` → `.gitignore`'a ekle, asla commit etme
- Supabase `SERVICE_ROLE` asla Flutter'da
- Smart-commit kaldırıldı — git commit'leri manuel
- `PROGRESS.md`: Claude yazar (içerik) + hook ekler (timestamp)
- Yeni projede: roadmap → CLAUDE.md → iskelet → Supabase → `.mcp.json`
