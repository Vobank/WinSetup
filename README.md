# WinSetup — чистая переустановка Windows 11

**[Русский](#русский) · [English](#english)**

> 🌐 **Язык скриптов: только русский** · **Scripts: Russian only**

Набор скриптов для чистой переустановки Windows 11 и последующей оптимизации: открытие официальной скачки, агрессивный оптимизатор (с сохранением Защитника), авто-применение через `autounattend.xml` и бэкап данных.

A toolkit for a clean Windows 11 reinstall and post-install optimization: opening the official download, an aggressive optimizer (keeping Defender on), auto-apply via `autounattend.xml`, and a data backup script.

---

## Русский

### Что внутри
- **`1-Открыть-официальную-скачку.ps1`** — открывает официальные страницы Microsoft и Rufus
- **`optimize.ps1`** / **`2-Оптимизация-ПОСЛЕ-установки.ps1`** — агрессивная чистка (реклама, телеметрия, мусор) + игровые твики. **Защитник НЕ отключается.**
- **`autounattend.xml`** — кладётся в корень установочной флешки → оптимизация применяется сама при первом входе
- **`3-Бэкап-данных.ps1`** — бэкап нужных папок перед переустановкой

### Как пользоваться
1. Поставить официальную Windows 11 (Media Creation Tool или ISO).
2. (Опц.) положить `autounattend.xml` на флешку — для авто-оптимизации.
3. После установки — запустить `optimize.ps1` от администратора.

### ⚠️
Скрипты меняют системные настройки/реестр. Применяйте осознанно. Оптимизатор намеренно **оставляет Защитник Windows включённым**.

---

## English

### What's inside
- **`1-Открыть-официальную-скачку.ps1`** — opens Microsoft's and Rufus's official pages
- **`optimize.ps1`** / **`2-Оптимизация-ПОСЛЕ-установки.ps1`** — aggressive cleanup (ads, telemetry, bloat) + gaming tweaks. **Defender is NOT disabled.**
- **`autounattend.xml`** — placed at the USB root → optimization runs automatically at first logon
- **`3-Бэкап-данных.ps1`** — back up needed folders before reinstalling

### How to use
1. Install official Windows 11 (Media Creation Tool or ISO).
2. (Optional) put `autounattend.xml` on the USB — for auto-optimization.
3. After install — run `optimize.ps1` as administrator.

### ⚠️
Scripts change system settings/registry. Apply with care. The optimizer deliberately **keeps Windows Defender on**.

---

### Технологии / Tech
PowerShell · Windows 11 · autounattend.xml
