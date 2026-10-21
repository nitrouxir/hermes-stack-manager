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

function Check-Service($name, $port, $url) {
    if (Test-PortOpen $port) {
        Write-Host "  [RUNNING] $name ($url)" -ForegroundColor Green
    } else {
        Write-Host "  [STOPPED] $name ($url)" -ForegroundColor Red
    }
}

Write-Host "=== Hermes Stack Service Status ===" -ForegroundColor Cyan
Check-Service "Hermes WebUI" 8787 "http://localhost:8787"
Check-Service "9Router" 20128 "http://localhost:20128"
