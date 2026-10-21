# ==============================================================================
#  Hermes Stack - One-Click Updater
# ==============================================================================
Write-Host "=== Starting Hermes Stack Update ===" -ForegroundColor Cyan

# 1. Stop active services
Write-Host "1. Stopping services..." -ForegroundColor Yellow
$stopScript = Join-Path $PSScriptRoot "stop.ps1"
if (-not (Test-Path $stopScript)) {
    $stopScript = "$env:USERPROFILE\.hermes-stack\stop.ps1"
}
if (Test-Path $stopScript) {
    powershell -ExecutionPolicy Bypass -File $stopScript
}

# 2. Update Hermes Agent
Write-Host "2. Updating Hermes Agent..." -ForegroundColor Yellow
if (Test-Path "$env:LOCALAPPDATA\hermes\bin\hermes.exe") {
    & "$env:LOCALAPPDATA\hermes\bin\hermes.exe" update
}

# 3. Update WebUI from GitHub
Write-Host "3. Updating Hermes WebUI..." -ForegroundColor Yellow
if (Test-Path "$env:USERPROFILE\hermes-webui") {
    Push-Location "$env:USERPROFILE\hermes-webui"
    git fetch origin
    $branch = "master"
    $checkMaster = git branch -r --list "origin/master"
    if (-not $checkMaster) { $branch = "main" }
    git checkout $branch 2>$null
    git reset --hard "origin/$branch"
    Pop-Location
    
    # Sync Python dependencies
    $uvExe = "$env:LOCALAPPDATA\hermes\bin\uv.exe"
    $agentPy = "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe"
    $webuiPy = "$env:USERPROFILE\hermes-webui\.venv\Scripts\python.exe"
    $py = if (Test-Path $agentPy) { $agentPy } else { $webuiPy }
    if (Test-Path $uvExe) {
        & $uvExe pip install -r "$env:USERPROFILE\hermes-webui\requirements.txt" --python $py
    } else {
        & $py -m pip install -r "$env:USERPROFILE\hermes-webui\requirements.txt"
    }
}

# 4. Update 9Router
Write-Host "4. Updating 9Router..." -ForegroundColor Yellow
npm install -g 9router@latest

Write-Host ""
Write-Host "=== Update completed successfully! ===" -ForegroundColor Green
$ans = Read-Host "Do you want to restart all services now? (y/N)"
if ($ans -match '^[Yy]$') {
    $startScript = Join-Path $PSScriptRoot "start.ps1"
    if (-not (Test-Path $startScript)) {
        $startScript = "$env:USERPROFILE\.hermes-stack\start.ps1"
    }
    if (Test-Path $startScript) {
        powershell -ExecutionPolicy Bypass -File $startScript
    }
}
