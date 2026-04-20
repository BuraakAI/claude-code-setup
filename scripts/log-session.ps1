# Claude Code — Session End Logger
# Runs automatically when Claude stops. Appends session marker to PROGRESS.md if it exists.

$progressFile = Join-Path (Get-Location) "PROGRESS.md"
$date = Get-Date -Format "yyyy-MM-dd HH:mm"

if (Test-Path $progressFile) {
    $marker = "`n---`n> Oturum kapandı: $date`n"
    Add-Content -Path $progressFile -Value $marker
    Write-Host "[log-session] PROGRESS.md guncellendi: $date"
} else {
    Write-Host "[log-session] PROGRESS.md bulunamadi - proje klasorunde degilsin veya dosya yok."
}
