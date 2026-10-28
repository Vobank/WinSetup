# ============================================================
#  ОПТИМИЗАТОР WINDOWS 11 (режим "по максимуму")
#  Запускать ПОСЛЕ чистой установки, от администратора.
#  Убирает рекламу/телеметрию/мусор, выжимает производительность.
#  !!! ЗАЩИТНИК WINDOWS НЕ ОТКЛЮЧАЕТСЯ — базовая защита остаётся.
#  Почти всё обратимо. Создай точку восстановления перед запуском.
# ============================================================

# --- самоповышение прав до администратора ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$ErrorActionPreference = 'SilentlyContinue'
function Step($t){ Write-Host "`n>>> $t" -ForegroundColor Cyan }
function Reg($path,$name,$val,$type='DWord'){ if(-not(Test-Path $path)){New-Item $path -Force|Out-Null}; New-ItemProperty -Path $path -Name $name -Value $val -PropertyType $type -Force|Out-Null }

Write-Host "=== ОПТИМИЗАЦИЯ WINDOWS 11 (максимум) ===" -ForegroundColor Green
Write-Host "Создаю точку восстановления..." -ForegroundColor Yellow
Enable-ComputerRestore -Drive "C:\" ; Checkpoint-Computer -Description "До оптимизации" -RestorePointType MODIFY_SETTINGS

# ---------------- 1. РЕКЛАМА И ПОДСКАЗКИ ----------------
Step "Отключаю рекламу, подсказки и 'рекомендации'"
$cdm = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
foreach($n in 'SubscribedContent-338388Enabled','SubscribedContent-338389Enabled','SubscribedContent-310093Enabled','SubscribedContent-338387Enabled','SubscribedContent-353694Enabled','SubscribedContent-353696Enabled','SystemPaneSuggestionsEnabled','SilentInstalledAppsEnabled','SoftLandingEnabled','RotatingLockScreenOverlayEnabled','PreInstalledAppsEnabled'){ Reg $cdm $n 0 }
Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" 'Enabled' 0          # рекламный ID
Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" 'Start_IrisRecommendations' 0
Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" 'DisableWindowsConsumerFeatures' 1
Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" 'DisableCloudOptimizedContent' 1

# ---------------- 2. ТЕЛЕМЕТРИЯ ----------------
Step "Отключаю телеметрию и слежку"
Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" 'AllowTelemetry' 0
Reg "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" 'AllowTelemetry' 0
Set-Service DiagTrack -StartupType Disabled; Stop-Service DiagTrack -Force
Set-Service dmwappushservice -StartupType Disabled; Stop-Service dmwappushservice -Force
Disable-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -TaskPath "\Microsoft\Windows\Application Experience\"
Disable-ScheduledTask -TaskName "ProgramDataUpdater" -TaskPath "\Microsoft\Windows\Application Experience\"
Disable-ScheduledTask -TaskName "Consolidator" -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\"
Disable-ScheduledTask -TaskName "UsbCeip" -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\"

# ---------------- 3. COPILOT / WIDGETS / BING В ПОИСКЕ ----------------
Step "Убираю Copilot, виджеты и Bing из поиска"
Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" 'TurnOffWindowsCopilot' 1
Reg "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" 'TurnOffWindowsCopilot' 1
Reg "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" 'AllowNewsAndInterests' 0                 # виджеты
Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" 'BingSearchEnabled' 0
Reg "HKCU:\Software\Policies\Microsoft\Windows\Explorer" 'DisableSearchBoxSuggestions' 1

# ---------------- 4. УДАЛЕНИЕ ВСТРОЕННОГО МУСОРА (UWP) ----------------
Step "Удаляю лишние встроенные приложения"
$bloat = @(
 'Clipchamp.Clipchamp','Microsoft.BingNews','Microsoft.BingWeather','Microsoft.BingSearch',
 'Microsoft.GetHelp','Microsoft.Getstarted','Microsoft.WindowsMaps','Microsoft.People',
 'Microsoft.MicrosoftOfficeHub','Microsoft.Office.OneNote','Microsoft.MicrosoftSolitaireCollection',
 'Microsoft.MicrosoftSticky Notes','Microsoft.Todos','Microsoft.WindowsFeedbackHub',
 'Microsoft.MixedReality.Portal','Microsoft.3DBuilder','Microsoft.Print3D','Microsoft.Microsoft3DViewer',
 'Microsoft.SkypeApp','Microsoft.Wallet','Microsoft.549981C3F5F10',   # Cortana
 'MicrosoftTeams','MSTeams','Microsoft.Windows.DevHome','Microsoft.OutlookForWindows',
 'Microsoft.PowerAutomateDesktop','Microsoft.ZuneVideo','Microsoft.ZuneMusic','Microsoft.GamingApp'
)
foreach($app in $bloat){
  Get-AppxPackage -AllUsers -Name $app | Remove-AppxPackage -AllUsers
  Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online
}
Write-Host "   (оставлены: Store, Калькулятор, Фото, Терминал, Xbox-сервисы для игр)" -ForegroundColor DarkGray

# ---------------- 5. ЛИШНИЕ СЛУЖБЫ ----------------
Step "Отключаю ненужные службы (безопасные)"
$svc = 'Fax','RetailDemo','MapsBroker','WalletService','PhoneSvc','MessagingService','PushToInstall','RemoteRegistry','WMPNetworkSvc','SharedAccess'
foreach($s in $svc){ Set-Service $s -StartupType Disabled; Stop-Service $s -Force }

# ---------------- 6. ПРОИЗВОДИТЕЛЬНОСТЬ / ИГРЫ ----------------
Step "Включаю игровые твики и максимальную производительность"
# план питания "Максимальная производительность"
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
# аппаратное планирование GPU (HAGS) — полезно для современных видеокарт
Reg "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" 'HwSchMode' 2
# Game Mode ВКЛ, фоновая запись Game DVR ВЫКЛ (экономит FPS)
Reg "HKCU:\Software\Microsoft\GameBar" 'AutoGameModeEnabled' 1
Reg "HKCU:\System\GameConfigStore" 'GameDVR_Enabled' 0
Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" 'AllowGameDVR' 0
# приоритет ресурсов играм
Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" 'GPU Priority' 8
Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" 'Priority' 6
Reg "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" 'Scheduling Category' 'High' 'String'
# визуальные эффекты в сторону быстродействия (но шрифты оставляем гладкими)
Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" 'VisualFXSetting' 2
# прозрачность и анимации — выкл (быстрее отклик)
Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" 'EnableTransparency' 0

# ---------------- 7. ЗАЩИТНИК — ПРОВЕРКА, ЧТО ВКЛЮЧЁН ----------------
Step "Проверяю, что Защитник ВКЛЮЧЁН (как и задумано)"
Set-MpPreference -DisableRealtimeMonitoring $false
$mp = Get-MpComputerStatus
Write-Host ("   Антивирус: {0} | Реалтайм: {1}" -f $mp.AntivirusEnabled, $mp.RealTimeProtectionEnabled) -ForegroundColor Green
Write-Host "   ВКЛЮЧИ 'Защиту от подделки' вручную: Параметры > Конфиденциальность и защита > Безопасность Windows > Защита от вирусов > Управление настройками > Защита от подделки = ВКЛ" -ForegroundColor Yellow

Write-Host "`n=== ГОТОВО. Перезагрузи компьютер. ===" -ForegroundColor Green
Write-Host "Если что-то не нравится — откат через точку восстановления (создана в начале)." -ForegroundColor DarkGray
pause
