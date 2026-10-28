# ============================================================
#  ОТКРЫТЬ ОФИЦИАЛЬНУЮ СКАЧКУ WINDOWS 11 PRO x64 (ENGLISH)
#  Скрипт НИЧЕГО не скачивает сам и не запускает чужой код —
#  он открывает официальные страницы Microsoft и Rufus,
#  чтобы ты скачал всё из первых рук и безопасно.
# ============================================================

Write-Host "=== Официальная установка Windows 11 Pro x64 (English) ===" -ForegroundColor Green
Write-Host @"

Открываю официальные страницы:
  1) Microsoft — Media Creation Tool и ISO (English, x64)
  2) Rufus — для записи ISO на флешку (если выберешь ISO)

Что делать:
  • Способ А (просто): скачай 'Create Windows 11 installation media',
    запусти, выбери язык English, вставь флешку 8+ ГБ — готово.
  • Способ Б: скачай 'Windows 11 Disk Image (ISO)', язык English,
    затем запиши его на флешку через Rufus.

  При установке выбери выпуск 'Windows 11 Pro'.
  Качай ТОЛЬКО с этих официальных сайтов — никаких сборок!
"@ -ForegroundColor Cyan

Start-Process "https://www.microsoft.com/software-download/windows11"
Start-Sleep -Seconds 1
Start-Process "https://rufus.ie"

Write-Host "`nСтраницы открыты в браузере." -ForegroundColor Green
pause
