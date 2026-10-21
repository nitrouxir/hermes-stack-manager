# ==============================================================================
#  Hermes Stack - Service Starter
# ==============================================================================
$PORT_WEBUI = 8787
$PORT_9ROUTER = 20128

function Test-PortOpen($port) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $ar = $client.BeginConnect("127.0.0.1", $port, $null, $null)
        $wait = $ar.AsyncWaitHandle.WaitOne(350, $false)
        if ($wait -and $client.Connected) {
            $client.EndConnect($ar)
            $client.Close()
            return $true
        }
        $client.Close()
        return $false
    } catch {
        return $false
    }
}

Write-Host '[Starting Hermes Stack Services...]' -ForegroundColor Cyan

# 1. Start 9Router
if (Test-PortOpen $PORT_9ROUTER) {
    Write-Host "  [OK] 9Router is already running on port $PORT_9ROUTER" -ForegroundColor Green
} else {
    Start-Process -WindowStyle Hidden -FilePath "cmd.exe" -ArgumentList "/c 9router -p $PORT_9ROUTER" -RedirectStandardOutput "$env:USERPROFILE\.hermes\9router.log"
    Start-Sleep -Seconds 3
    Write-Host "  [OK] 9Router started on port $PORT_9ROUTER" -ForegroundColor Green
}

# 2. Start Hermes WebUI
if (Test-PortOpen $PORT_WEBUI) {
    Write-Host "  [OK] Hermes WebUI is already running on port $PORT_WEBUI" -ForegroundColor Green
} else {
    $pythonExe = "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe"
    if (-not (Test-Path $pythonExe)) {
        $pythonExe = "$env:USERPROFILE\hermes-webui\.venv\Scripts\python.exe"
    }
    
    $env:PYTHONPATH = "$env:USERPROFILE\hermes-webui;$env:LOCALAPPDATA\hermes\hermes-agent"
    Push-Location "$env:USERPROFILE\hermes-webui"
    Start-Process -WindowStyle Hidden -FilePath $pythonExe -ArgumentList "bootstrap.py --no-browser $PORT_WEBUI" -WorkingDirectory "$env:USERPROFILE\hermes-webui" -RedirectStandardOutput "$env:USERPROFILE\.hermes\webui.log" -RedirectStandardError "$env:USERPROFILE\.hermes\webui_err.log"
    Pop-Location
    Start-Sleep -Seconds 3
    Write-Host "  [OK] Hermes WebUI started on port $PORT_WEBUI" -ForegroundColor Green
}

Write-Host ""
Write-Host "All active services ready:" -ForegroundColor Cyan
Write-Host "  Hermes WebUI : http://localhost:$PORT_WEBUI" -ForegroundColor White
Write-Host "  9Router API  : http://localhost:$PORT_9ROUTER" -ForegroundColor White
