# ==============================================================================
#  Hermes Stack - Service Stopper
# ==============================================================================
Write-Host '[Stopping Hermes Stack Services...]' -ForegroundColor Yellow

$ports = @(8787, 20128, 20129)
foreach ($p in $ports) {
    try {
        $conns = Get-NetTCPConnection -LocalPort $p -ErrorAction SilentlyContinue
        if ($conns) {
            $pids = $conns | Select-Object -ExpandProperty OwningProcess -Unique
            foreach ($procId in $pids) {
                if ($procId -gt 0) {
                    Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
                    Write-Host "  [STOPPED] Service on port $p (PID: $procId)" -ForegroundColor DarkGray
                }
            }
        }
    } catch {}
}

# Also stop named processes if still lingering
Get-Process 9router,omniroute -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host '[OK] All Hermes Stack services stopped.' -ForegroundColor Green
