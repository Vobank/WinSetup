# ============================================================
#  БЭКАП ВАЖНЫХ ДАННЫХ С ДИСКА C: ПЕРЕД ПЕРЕУСТАНОВКОЙ
#  Копирует Документы, Изображения, Музыку, (по выбору) Видео и
#  Загрузки, файлы со стола. Запускать ДО форматирования C:.
# ============================================================

$ErrorActionPreference = 'Continue'

# --- куда копировать (флешка/внешний диск) ---
Write-Host "Подключи внешний диск/флешку." -ForegroundColor Cyan
$dst = Read-Host "Введи путь назначения (например E:\Backup)"
if ([string]::IsNullOrWhiteSpace($dst)) { Write-Host "Путь не задан. Выход."; exit }
New-Item -ItemType Directory -Force -Path $dst | Out-Null

$src = $env:USERPROFILE
$root = (Get-Item $dst).PSDrive.Name

# что копируем целиком
$copyFull = @('Documents','Pictures','Music')
# что копируем, но ОСТОРОЖНО (крупное/с мусором)
$copyBig  = @('Videos','Downloads')

function Copy-Folder($name){
  $from = Join-Path $src $name
  if(-not(Test-Path $from)){ return }
  $to = Join-Path $dst $name
  $size = [math]::Round((Get-ChildItem $from -Recurse -File -EA SilentlyContinue | Measure-Object Length -Sum).Sum/1GB,2)
  Write-Host ("Копирую {0} ({1} ГБ)..." -f $name,$size) -ForegroundColor Cyan
  # robocopy: надёжно, с повтором; /XJ пропускает точки соединения
  robocopy $from $to /E /XJ /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
}

Write-Host "`n--- ОБЫЧНЫЕ ПАПКИ ---" -ForegroundColor Green
foreach($f in $copyFull){ Copy-Folder $f }

Write-Host "`n--- КРУПНЫЕ ПАПКИ (проверь, что хватает места) ---" -ForegroundColor Yellow
$free = [math]::Round((Get-PSDrive $root).Free/1GB,1)
Write-Host "Свободно на $($root): $free ГБ" -ForegroundColor Yellow
foreach($f in $copyBig){
  $ans = Read-Host "Копировать '$f'? (д/н)"
  if($ans -match '^[дdyY]'){ Copy-Folder $f }
}

Write-Host "`n--- РАБОЧИЙ СТОЛ ---" -ForegroundColor Green
$deskTo = Join-Path $dst 'Desktop'
New-Item -ItemType Directory -Force -Path $deskTo | Out-Null
# что пропустить на рабочем столе (части имён; допиши своё)
$skip = @()
Get-ChildItem (Join-Path $src 'Desktop') | Where-Object {
  $n = $_.Name
  -not ($skip | Where-Object { $n -like "*$_*" })
} | ForEach-Object {
  Write-Host "  + $($_.Name)" -ForegroundColor DarkGray
  if($_.PSIsContainer){ robocopy $_.FullName (Join-Path $deskTo $_.Name) /E /XJ /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null }
  else { Copy-Item $_.FullName $deskTo -Force }
}


Write-Host "`n=== БЭКАП ГОТОВ: $dst ===" -ForegroundColor Green
pause
