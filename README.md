# Claude Code Setup

Flutter + Supabase geliştirme için hazır Claude Code global konfigürasyonu.  
Skills, MCP sunucuları ve oturum hook'larını içerir.

> Tam kullanım kılavuzu: [KULLANIM.md](KULLANIM.md)

## İçerik

| Dosya/Klasör | Açıklama |
|---|---|
| `CLAUDE.md` | Global kurallar — Flutter/Riverpod standartları, yasaklar |
| `settings.json` | Stop hook — oturum sonu logger tetikler |
| `scripts/log-session.ps1` | Oturum kapandığında `PROGRESS.md`'e zaman damgası yazar |
| `skills/` | Özel skill'ler (bug-hunter, build-feature, supabase-expert vb.) |
| `mcp.example.json` | MCP sunucu şablonu |
| `KULLANIM.md` | Detaylı Türkçe kullanım rehberi |

## Kurulum

```bash
# 1. Repoyu klonla
git clone https://github.com/BuraakAI/claude-code-setup.git

# 2. Dosyaları ~/.claude/ konumuna kopyala
# Windows:
xcopy /E /Y claude-code-setup\* %USERPROFILE%\.claude\

# macOS/Linux:
cp -r claude-code-setup/* ~/.claude/
```

### MCP Ayarı

```bash
cp mcp.example.json ~/.claude/mcp.json
# mcp.json içindeki API key değerlerini doldur
```

## Skills

| Skill | Komut | Açıklama |
|---|---|---|
| bug-hunter | `/bug-hunter` | Sistematik hata tespiti ve düzeltme |
| build-feature | `/build-feature` | Sıfırdan feature geliştirme |
| supabase-expert | `/supabase-expert` | Supabase RLS, edge functions, schema |
| security-audit | `/security-audit` | Güvenlik açığı taraması |
| token-saver | `/token-saver` | Context/token optimizasyonu |
| new-project | `/new-project` | Flutter projesi scaffold |
| default-mode | `/default-mode` | Davranış sıfırlama |

## Oturum Logger Hook

Her `claude` oturumu kapandığında `log-session.ps1` otomatik çalışır.  
Proje klasöründe `PROGRESS.md` varsa kapanış zaman damgası ekler.

> **Not:** `settings.json`'daki hook path'i kendi sisteminize göre güncelleyin.

## Gereksinimler

- [Claude Code CLI](https://claude.ai/code)
- Node.js (MCP sunucuları için)
- PowerShell (Windows hook için)
