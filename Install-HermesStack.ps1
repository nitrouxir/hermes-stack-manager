# ==============================================================================
#  Hermes Stack - Automated Full Installer & Setup Script for Windows (v2.0)
#  Installs: Git, Node.js, Python, uv, 9Router, Hermes WebUI, Hermes Agent
# ==============================================================================

$ErrorActionPreference = "Continue"

function Write-Step($title) {
    Write-Host ""
    Write-Host ("=" * 70) -ForegroundColor Cyan
    Write-Host "  $title" -ForegroundColor White
    Write-Host ("=" * 70) -ForegroundColor Cyan
}

function Log-Ok($msg) { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Log-Info($msg) { Write-Host "  [->] $msg" -ForegroundColor Cyan }
function Log-Warn($msg) { Write-Host "  [!]  $msg" -ForegroundColor Yellow }
function Log-Err($msg) { Write-Host "  [X]  $msg" -ForegroundColor Red }

Clear-Host
Write-Host @"
  __  __                                  ____  _             _    
 |  \/  | ___ _ __ _ __ ___   ___  ___    / ___|| |_ __ _  ___| | __
 | |\/| |/ _ \ '__| '_ ` _ \ / _ \/ __|   \___ \| __/ _` |/ __| |/ /
 | |  | |  __/ |  | | | | | |  __/\__ \    ___) | || (_| | (__|   < 
 |_|  |_|\___|_|  |_| |_| |_|\___||___/   |____/ \__\__,_|\___|_|\_\
======================================================================
      Automated Installer & Environment Setup for Windows (v2.0)
======================================================================
"@ -ForegroundColor Magenta

# 1. Enable Script Execution Policy for Current User
Write-Step "1/6. تنظیم پالیسی اجرای اسکریپت‌ها (PowerShell ExecutionPolicy)"
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Log-Ok "پالیسی RemoteSigned برای کاربر جاری با موفقیت تنظیم شد."
} catch {
    Log-Warn "تنظیم خودکار پالیسی با خطا مواجه شد؛ اما فرآیند ادامه می‌یابد."
}

# 2. Check & Install Prerequisites
Write-Step "2/6. بررسی پیش‌نیازهای سیستمی (Git, Node.js, Python)"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Log-Warn "Git یافت نشد. در حال نصب خودکار از طریق winget..."
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
} else {
    Log-Ok "Git نصب است."
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Log-Warn "Node.js یافت نشد. در حال نصب خودکار از طریق winget..."
    winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements
} else {
    Log-Ok "Node.js نصب است ($(node --version))."
}

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Log-Warn "Python یافت نشد. در حال نصب خودکار از طریق winget..."
    winget install --id Python.Python.3.12 -e --source winget --accept-package-agreements --accept-source-agreements
} else {
    Log-Ok "Python نصب است ($(python --version))."
}

# 3. Check & Install 9Router
Write-Step "3/6. بررسی و نصب 9Router (پورت 20128)"
Log-Info "در حال نصب/به‌روزرسانی 9Router از طریق npm..."
npm install -g 9router@latest
Log-Ok "9Router در دسترس و به‌روز است."

# 4. Check & Install Hermes Agent
Write-Step "4/6. بررسی و راه‌اندازی Hermes Agent (CLI)"
$hermesExe = "$env:LOCALAPPDATA\hermes\bin\hermes.exe"
if (-not (Test-Path $hermesExe)) {
    Log-Info "در حال دانلود و نصب رسمی Hermes Agent..."
    try {
        Invoke-RestMethod -Uri "https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1" | Invoke-Expression
        Log-Ok "Hermes Agent با موفقیت نصب شد."
    } catch {
        Log-Warn "نصب رسمی با خطا مواجه شد، در حال تلاش برای روش مستقیم..."
        $hermesLocal = Join-Path $env:LOCALAPPDATA "hermes"
        $hermesAgentDir = Join-Path $hermesLocal "hermes-agent"
        New-Item -ItemType Directory -Force -Path $hermesLocal | Out-Null
        git clone https://github.com/NousResearch/hermes-agent.git $hermesAgentDir
        $agentVenv = Join-Path $hermesAgentDir "venv"
        $agentPython = Join-Path $agentVenv "Scripts\python.exe"
        python -m venv $agentVenv
        & $agentPython -m pip install --upgrade pip
        & $agentPython -m pip install -e $hermesAgentDir
    }
} else {
    Log-Ok "Hermes Agent در دسترس است."
}

# 5. Check & Install Hermes WebUI
Write-Step "5/6. بررسی و راه‌اندازی Hermes WebUI (پورت 8787)"
$webUiDir = Join-Path $env:USERPROFILE "hermes-webui"
if (-not (Test-Path $webUiDir)) {
    Log-Info "در حال دانلود ریپازیتوری Hermes WebUI..."
    git clone https://github.com/nesquena/hermes-webui.git $webUiDir
} else {
    Log-Ok "پوشه hermes-webui موجود است. در حال دریافت آخرین آپدیت‌ها..."
    Push-Location $webUiDir
    git fetch origin
    git checkout master -ErrorAction SilentlyContinue
    git merge origin/master -ErrorAction SilentlyContinue
    Pop-Location
}

# Install / Sync Python dependencies for WebUI
$uvExe = "$env:LOCALAPPDATA\hermes\bin\uv.exe"
$agentPython = "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe"
$reqFile = Join-Path $webUiDir "requirements.txt"
if (Test-Path $uvExe -and (Test-Path $agentPython)) {
    Log-Info "در حال سینک سریع پکیج‌های پایتون WebUI با ابزار uv..."
    & $uvExe pip install -r $reqFile --python $agentPython
} else {
    $webUiVenv = Join-Path $webUiDir ".venv"
    $webUiPython = Join-Path $webUiVenv "Scripts\python.exe"
    if (-not (Test-Path $webUiPython)) {
        python -m venv $webUiVenv
    }
    & $webUiPython -m pip install -r $reqFile -ErrorAction SilentlyContinue
}
Log-Ok "پکیج‌ها و کدهای WebUI آماده شد."

# Ensure Hermes Configuration points to 9Router
$hermesDir = Join-Path $env:USERPROFILE ".hermes"
$appDataHermes = Join-Path $env:LOCALAPPDATA "hermes"
New-Item -ItemType Directory -Force -Path $hermesDir | Out-Null
New-Item -ItemType Directory -Force -Path $appDataHermes | Out-Null

$apiKey = "sk-" + [Guid]::NewGuid().ToString("N")
$configContent = @"
model:
  default: ag/gemini-3.8-flash
  provider: openai-api
  base_url: http://127.0.0.1:20128/v1
  api_key: $apiKey
agent:
  max_turns: 90
terminal:
  backend: local
  timeout: 180
"@

Set-Content -Path (Join-Path $hermesDir "config.yaml") -Value $configContent -Encoding UTF8
Set-Content -Path (Join-Path $appDataHermes "config.yaml") -Value $configContent -Encoding UTF8
Log-Ok "فایل‌های کانفیگ هرمس با اتصال به 9Router تنظیم شدند."

# 6. Deploy Management Scripts & Desktop Shortcut
Write-Step "6/6. ایجاد کنترل پنل دسکتاپ و اسکریپت‌های مدیریت"
$stackDir = Join-Path $env:USERPROFILE ".hermes-stack"
New-Item -ItemType Directory -Force -Path $stackDir | Out-Null

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$managerSubDir = Join-Path $stackDir "HermesManager"
New-Item -ItemType Directory -Force -Path $managerSubDir | Out-Null

$scriptsToDeploy = @("HermesManager.ps1", "Run-Manager.bat", "start.ps1", "stop.ps1", "status.ps1", "update.ps1")
foreach ($sf in $scriptsToDeploy) {
    $srcFile = Join-Path $scriptDir $sf
    if (Test-Path $srcFile) {
        Copy-Item $srcFile (Join-Path $stackDir $sf) -Force
        Copy-Item $srcFile (Join-Path $managerSubDir $sf) -Force
    }
}

# Desktop Shortcut to Run-Manager.bat
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop "Hermes Stack Manager.lnk"
$wsh = New-Object -ComObject WScript.Shell
$shortcut = $wsh.CreateShortcut($shortcutPath)
$shortcut.TargetPath = Join-Path $stackDir "Run-Manager.bat"
$shortcut.WorkingDirectory = $stackDir
$shortcut.Description = "Hermes AI Stack Control Center"
$shortcut.IconLocation = "shell32.dll,14"
$shortcut.Save()
Log-Ok "شورتکات دسکتاپ ساخته شد: $shortcutPath"

Write-Host ""
Write-Host ("*" * 70) -ForegroundColor Green
Write-Host "  تمام بخش‌های هرمس استک با موفقیت نصب و آماده شدند!" -ForegroundColor Green
Write-Host "  کنترل پنل Hermes Stack Manager روی دسکتاپ قرار گرفت." -ForegroundColor Green
Write-Host ("*" * 70) -ForegroundColor Green
Write-Host ""
Write-Host "برای اجرای کنترل پنل، کلید اینتر را بزنید..." -ForegroundColor Yellow
Read-Host
Start-Process (Join-Path $stackDir "Run-Manager.bat")
