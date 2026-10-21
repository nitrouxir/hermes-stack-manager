<#
================================================================================
  Hermes AI Stack - Desktop Control Center & Installer (v2.0)
  GUI Manager for Hermes Agent, Hermes WebUI, and 9Router
================================================================================
#>

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Drawing

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Hermes Stack Manager (v2.0)"
        Height="820" Width="920"
        MinHeight="700" MinWidth="800"
        WindowStartupLocation="CenterScreen"
        Background="#0B132B"
        Foreground="#F8FAFC"
        FontFamily="Segoe UI, Tahoma">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="12,6"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="Border" Background="{TemplateBinding Background}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Border" Property="Opacity" Value="0.85"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="Border" Property="Opacity" Value="0.7"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="130"/>
        </Grid.RowDefinitions>

        <!-- 1. Header -->
        <Border Grid.Row="0" Background="#1C2541" CornerRadius="12" Padding="20,15" Margin="0,0,0,15" BorderBrush="#3A506B" BorderThickness="1">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Grid.Column="0">
                    <StackPanel Orientation="Horizontal">
                        <TextBlock Text="🚀" FontSize="26" VerticalAlignment="Center" Margin="0,0,10,0"/>
                        <TextBlock Text="Hermes AI Stack Control Center" FontSize="22" FontWeight="Bold" Foreground="#FFFFFF" VerticalAlignment="Center"/>
                    </StackPanel>
                    <TextBlock Text="مدیریت، راه‌اندازی، آپدیت و بررسی زنده سرویس‌های اکوسیستم هوش مصنوعی هرمس" FontSize="13" Foreground="#94A3B8" Margin="36,4,0,0"/>
                </StackPanel>
                <StackPanel Grid.Column="1" VerticalAlignment="Center" Orientation="Horizontal">
                    <Border Name="BadgeGlobalStatus" Background="#10B981" CornerRadius="20" Padding="14,6">
                        <TextBlock Name="TextGlobalStatus" Text="بررسی وضعیت..." FontWeight="Bold" Foreground="#FFFFFF" FontSize="12"/>
                    </Border>
                </StackPanel>
            </Grid>
        </Border>

        <!-- 2. Master Action Bar -->
        <Grid Grid.Row="1" Margin="0,0,0,15">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Button Name="BtnStartAll" Grid.Column="0" Content="🚀 روشن کردن همه" Background="#10B981" Margin="0,0,6,0" Height="40" FontSize="14"/>
            <Button Name="BtnStopAll" Grid.Column="1" Content="🛑 توقف همه" Background="#EF4444" Margin="6,0,6,0" Height="40" FontSize="14"/>
            <Button Name="BtnUpdateMaster" Grid.Column="2" Content="🔄 آپدیت استک" Background="#8B5CF6" Margin="6,0,6,0" Height="40" FontSize="14"/>
            <Button Name="BtnRefresh" Grid.Column="3" Content="🔃 بررسی وضعیت" Background="#3B82F6" Margin="6,0,0,0" Height="40" FontSize="14"/>
        </Grid>

        <!-- 3. The 4 Cards in 2x2 Grid -->
        <Grid Grid.Row="2" Margin="0,0,0,15">
            <Grid.RowDefinitions>
                <RowDefinition Height="*"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Card 1: Hermes Agent -->
            <Border Grid.Row="0" Grid.Column="0" Background="#1C2541" CornerRadius="10" Margin="0,0,8,8" Padding="16" BorderBrush="#3A506B" BorderThickness="1">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <DockPanel Grid.Row="0">
                        <StackPanel Orientation="Horizontal" DockPanel.Dock="Left">
                            <TextBlock Text="🧠" FontSize="20" Margin="0,0,8,0"/>
                            <TextBlock Text="Hermes Agent" FontSize="17" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </StackPanel>
                        <Border Name="BadgeAgent" HorizontalAlignment="Right" Background="#334155" CornerRadius="12" Padding="10,3">
                            <TextBlock Name="TextStatusAgent" Text="نامشخص" FontSize="11" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </Border>
                    </DockPanel>
                    <StackPanel Grid.Row="1" Margin="0,10,0,0">
                        <TextBlock Text="نقش: ایجنت خودکار هوش مصنوعی و کدنویسی در ترمینال" Foreground="#CBD5E1" FontSize="12" TextWrapping="Wrap"/>
                        <TextBlock Text="دسترسی: دستور ترمینال hermes" Foreground="#64748B" FontSize="11" Margin="0,4,0,0"/>
                        <TextBlock Text="مدل پیش‌فرض: متصل مستقیم به 9Router" Foreground="#64748B" FontSize="11"/>
                    </StackPanel>
                    <Grid Grid.Row="2" Margin="0,10,0,0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Name="BtnOpenAgentTerminal" Grid.Column="0" Content="💻 اجرای ترمینال" Background="#3B82F6" Margin="0,0,4,0"/>
                        <Button Name="BtnEditAgentConfig" Grid.Column="1" Content="⚙️ تنظیمات Config" Background="#475569" Margin="4,0,0,0"/>
                    </Grid>
                </Grid>
            </Border>

            <!-- Card 2: Hermes WebUI -->
            <Border Grid.Row="0" Grid.Column="1" Background="#1C2541" CornerRadius="10" Margin="8,0,0,8" Padding="16" BorderBrush="#3A506B" BorderThickness="1">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <DockPanel Grid.Row="0">
                        <StackPanel Orientation="Horizontal" DockPanel.Dock="Left">
                            <TextBlock Text="🖥️" FontSize="20" Margin="0,0,8,0"/>
                            <TextBlock Text="Hermes WebUI" FontSize="17" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </StackPanel>
                        <Border Name="BadgeWebUI" HorizontalAlignment="Right" Background="#334155" CornerRadius="12" Padding="10,3">
                            <TextBlock Name="TextStatusWebUI" Text="بررسی..." FontSize="11" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </Border>
                    </DockPanel>
                    <StackPanel Grid.Row="1" Margin="0,10,0,0">
                        <TextBlock Text="نقش: محیط وب گرافیکی برای چت و مدیریت ایجنت هرمس" Foreground="#CBD5E1" FontSize="12" TextWrapping="Wrap"/>
                        <TextBlock Text="آدرس وب: http://127.0.0.1:8787" Foreground="#0EA5E9" FontWeight="SemiBold" FontSize="12" Margin="0,4,0,0"/>
                        <TextBlock Text="قابلیت‌ها: چت تعاملی، مدیریت نشست‌ها، ابزارها و سوابق" Foreground="#64748B" FontSize="11"/>
                    </StackPanel>
                    <Grid Grid.Row="2" Margin="0,10,0,0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Name="BtnOpenWebUI" Grid.Column="0" Content="🌐 ورود به لینک" Background="#0EA5E9" Margin="0,0,4,0"/>
                        <Button Name="BtnStartWebUI" Grid.Column="1" Content="▶ استارت" Background="#10B981" Margin="4,0,4,0"/>
                        <Button Name="BtnStopWebUI" Grid.Column="2" Content="⏹ توقف" Background="#EF4444" Margin="4,0,0,0"/>
                    </Grid>
                </Grid>
            </Border>

            <!-- Card 3: 9Router -->
            <Border Grid.Row="1" Grid.Column="0" Background="#1C2541" CornerRadius="10" Margin="0,8,8,0" Padding="16" BorderBrush="#3A506B" BorderThickness="1">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <DockPanel Grid.Row="0">
                        <StackPanel Orientation="Horizontal" DockPanel.Dock="Left">
                            <TextBlock Text="🔀" FontSize="20" Margin="0,0,8,0"/>
                            <TextBlock Text="9Router" FontSize="17" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </StackPanel>
                        <Border Name="Badge9Router" HorizontalAlignment="Right" Background="#334155" CornerRadius="12" Padding="10,3">
                            <TextBlock Name="TextStatus9Router" Text="بررسی..." FontSize="11" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </Border>
                    </DockPanel>
                    <StackPanel Grid.Row="1" Margin="0,10,0,0">
                        <TextBlock Text="نقش: گیت‌وی/پروکسی هوش مصنوعی برای مدیریت کلیدها و مدل‌ها" Foreground="#CBD5E1" FontSize="12" TextWrapping="Wrap"/>
                        <TextBlock Text="آدرس وب: http://127.0.0.1:20128" Foreground="#0EA5E9" FontWeight="SemiBold" FontSize="12" Margin="0,4,0,0"/>
                        <TextBlock Text="پرووایدرها: Gemini, Claude, OpenAI, DeepSeek, Antigravity" Foreground="#64748B" FontSize="11"/>
                    </StackPanel>
                    <Grid Grid.Row="2" Margin="0,10,0,0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Name="BtnOpen9Router" Grid.Column="0" Content="🌐 ورود به لینک" Background="#0EA5E9" Margin="0,0,4,0"/>
                        <Button Name="BtnStart9Router" Grid.Column="1" Content="▶ استارت" Background="#10B981" Margin="4,0,4,0"/>
                        <Button Name="BtnStop9Router" Grid.Column="2" Content="⏹ توقف" Background="#EF4444" Margin="4,0,0,0"/>
                    </Grid>
                </Grid>
            </Border>

            <!-- Card 4: Maintenance & Updates -->
            <Border Grid.Row="1" Grid.Column="1" Background="#1C2541" CornerRadius="10" Margin="8,8,0,0" Padding="16" BorderBrush="#3A506B" BorderThickness="1">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    <DockPanel Grid.Row="0">
                        <StackPanel Orientation="Horizontal" DockPanel.Dock="Left">
                            <TextBlock Text="⚡" FontSize="20" Margin="0,0,8,0"/>
                            <TextBlock Text="مدیریت و آپدیت استک" FontSize="17" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </StackPanel>
                        <Border Name="BadgeUpdate" HorizontalAlignment="Right" Background="#8B5CF6" CornerRadius="12" Padding="10,3">
                            <TextBlock Name="TextStatusUpdate" Text="آماده آپدیت 🚀" FontSize="11" FontWeight="Bold" Foreground="#FFFFFF"/>
                        </Border>
                    </DockPanel>
                    <StackPanel Grid.Row="1" Margin="0,10,0,0">
                        <TextBlock Text="قابلیت‌ها: به‌روزرسانی سریع با ۱ کلیک (هرمس، وب‌یو‌آی و ۹روتر)" Foreground="#CBD5E1" FontSize="12" TextWrapping="Wrap"/>
                        <TextBlock Text="پوشه داده‌ها: %USERPROFILE%\.hermes" Foreground="#0EA5E9" FontWeight="SemiBold" FontSize="11" Margin="0,4,0,0"/>
                        <TextBlock Text="نگهداری: باز کردن مستقیم پوشه سوابق و تنظیمات" Foreground="#64748B" FontSize="11"/>
                    </StackPanel>
                    <Grid Grid.Row="2" Margin="0,10,0,0">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Button Name="BtnRunUpdate" Grid.Column="0" Content="🔄 آپدیت کامل استک" Background="#8B5CF6" Margin="0,0,4,0"/>
                        <Button Name="BtnOpenHermesDir" Grid.Column="1" Content="📂 پوشه کانفیگ" Background="#475569" Margin="4,0,0,0"/>
                    </Grid>
                </Grid>
            </Border>
        </Grid>

        <!-- 4. Footer Console Log -->
        <Border Grid.Row="3" Background="#0D1B2A" CornerRadius="8" Padding="12" BorderBrush="#3A506B" BorderThickness="1">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <DockPanel Grid.Row="0" Margin="0,0,0,6">
                    <TextBlock Text="📋 لاگ و گزارش زنده وضعیت (Real-time Log):" FontSize="12" FontWeight="SemiBold" Foreground="#94A3B8"/>
                    <TextBlock Name="TextAutoRefreshIndicator" Text="بررسی خودکار پورت‌ها فعال است ⏱" FontSize="11" Foreground="#64748B" HorizontalAlignment="Right"/>
                </DockPanel>
                <TextBox Name="TxtLog" Grid.Row="1" Background="#050B14" Foreground="#10B981" FontFamily="Consolas, Courier New" FontSize="11"
                         IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap" BorderThickness="0" Padding="6"/>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Element references
$BtnStartAll             = $window.FindName("BtnStartAll")
$BtnStopAll              = $window.FindName("BtnStopAll")
$BtnUpdateMaster         = $window.FindName("BtnUpdateMaster")
$BtnRefresh              = $window.FindName("BtnRefresh")

$BadgeGlobalStatus       = $window.FindName("BadgeGlobalStatus")
$TextGlobalStatus        = $window.FindName("TextGlobalStatus")

$BadgeAgent              = $window.FindName("BadgeAgent")
$TextStatusAgent         = $window.FindName("TextStatusAgent")
$BtnOpenAgentTerminal    = $window.FindName("BtnOpenAgentTerminal")
$BtnEditAgentConfig      = $window.FindName("BtnEditAgentConfig")

$BadgeWebUI              = $window.FindName("BadgeWebUI")
$TextStatusWebUI         = $window.FindName("TextStatusWebUI")
$BtnOpenWebUI            = $window.FindName("BtnOpenWebUI")
$BtnStartWebUI           = $window.FindName("BtnStartWebUI")
$BtnStopWebUI            = $window.FindName("BtnStopWebUI")

$Badge9Router            = $window.FindName("Badge9Router")
$TextStatus9Router       = $window.FindName("TextStatus9Router")
$BtnOpen9Router          = $window.FindName("BtnOpen9Router")
$BtnStart9Router         = $window.FindName("BtnStart9Router")
$BtnStop9Router          = $window.FindName("BtnStop9Router")

$BtnRunUpdate            = $window.FindName("BtnRunUpdate")
$BtnOpenHermesDir        = $window.FindName("BtnOpenHermesDir")

$TxtLog                  = $window.FindName("TxtLog")

# Helper: Append to Log
function Log-Msg($msg) {
    $time = (Get-Date).ToString("HH:mm:ss")
    $TxtLog.AppendText("[$time] $msg`r`n")
    $TxtLog.ScrollToEnd()
}

# Helper: Open Browser
function Open-Url($url) {
    Log-Msg "در حال باز کردن مرورگر: $url"
    try {
        [System.Diagnostics.Process]::Start($url) | Out-Null
    } catch {
        Start-Process $url
    }
}

# Helper: Highly Reliable Socket Port Test (Non-blocking, accurate)
function Test-ServicePort($port) {
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $ar = $tcp.BeginConnect("127.0.0.1", $port, $null, $null)
        $wait = $ar.AsyncWaitHandle.WaitOne(350, $false)
        if ($wait -and $tcp.Connected) {
            $tcp.EndConnect($ar)
            $tcp.Close()
            return $true
        }
        $tcp.Close()
        return $false
    } catch {
        return $false
    }
}

# Helper: Stop Port Process
function Stop-ServicePort($port, $name) {
    Log-Msg "در حال بستن سرویس $name روی پورت $port..."
    try {
        $conns = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
        if ($conns) {
            $pids = $conns | Select-Object -ExpandProperty OwningProcess -Unique
            foreach ($p in $pids) {
                if ($p -gt 0) {
                    Stop-Process -Id $p -Force -ErrorAction SilentlyContinue
                    Log-Msg "فرایند $name با PID $p متوقف شد."
                }
            }
        } else {
            Log-Msg "سرویس $name در حال اجرا نبود."
        }
    } catch {
        Log-Msg "خطا در بستن $name : $_"
    }
    Update-AllStatuses
}

# Check all statuses
function Update-AllStatuses {
    $bc = New-Object System.Windows.Media.BrushConverter

    # 1. Hermes Agent
    $agentCmd = (Get-Command hermes.exe -ErrorAction SilentlyContinue) -or (Get-Command hermes -ErrorAction SilentlyContinue)
    if ($agentCmd) {
        $BadgeAgent.Background = $bc.ConvertFromString("#10B981")
        $TextStatusAgent.Text = "آماده به کار ✔"
    } else {
        $BadgeAgent.Background = $bc.ConvertFromString("#EF4444")
        $TextStatusAgent.Text = "نصب نشده ✖"
    }

    # 2. WebUI (8787)
    $webuiRunning = Test-ServicePort 8787
    if ($webuiRunning) {
        $BadgeWebUI.Background = $bc.ConvertFromString("#10B981")
        $TextStatusWebUI.Text = "فعال (RUNNING) ✔"
    } else {
        $BadgeWebUI.Background = $bc.ConvertFromString("#EF4444")
        $TextStatusWebUI.Text = "متوقف (STOPPED) ✖"
    }

    # 3. 9Router (20128)
    $nineRouterRunning = Test-ServicePort 20128
    if ($nineRouterRunning) {
        $Badge9Router.Background = $bc.ConvertFromString("#10B981")
        $TextStatus9Router.Text = "فعال (RUNNING) ✔"
    } else {
        $Badge9Router.Background = $bc.ConvertFromString("#EF4444")
        $TextStatus9Router.Text = "متوقف (STOPPED) ✖"
    }

    # Global summary (2 main services)
    $activeCount = 0
    if ($webuiRunning) { $activeCount++ }
    if ($nineRouterRunning) { $activeCount++ }

    if ($activeCount -eq 2) {
        $BadgeGlobalStatus.Background = $bc.ConvertFromString("#10B981")
        $TextGlobalStatus.Text = "هر ۲ سرویس فعال هستند (2/2) ✔"
    } elseif ($activeCount -gt 0) {
        $BadgeGlobalStatus.Background = $bc.ConvertFromString("#F59E0B")
        $TextGlobalStatus.Text = "$activeCount سرویس از ۲ سرویس فعال است"
    } else {
        $BadgeGlobalStatus.Background = $bc.ConvertFromString("#EF4444")
        $TextGlobalStatus.Text = "تمام سرویس‌ها متوقف هستند (0/2)"
    }
}

# Button Actions
$BtnRefresh.Add_Click({
    Log-Msg "به‌روزرسانی وضعیت سرویس‌ها..."
    Update-AllStatuses
})

$BtnStartAll.Add_Click({
    Log-Msg "روشن کردن تمام سرویس‌های هرمس..."
    $startScript = Join-Path $env:USERPROFILE ".hermes-stack\start.ps1"
    if (Test-Path $startScript) {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$startScript`"" -WindowStyle Hidden
    } else {
        # Fallback inline start
        Start-Process cmd.exe -ArgumentList "/c 9router -p 20128" -WindowStyle Hidden
        $pythonExe = "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe"
        if (Test-Path $pythonExe) {
            $env:PYTHONPATH = "$env:USERPROFILE\hermes-webui;$env:LOCALAPPDATA\hermes\hermes-agent"
            Start-Process -WindowStyle Hidden -FilePath $pythonExe -ArgumentList "bootstrap.py --no-browser 8787" -WorkingDirectory "$env:USERPROFILE\hermes-webui"
        }
    }
    Start-Sleep -Seconds 3
    Update-AllStatuses
    Log-Msg "سرویس‌های استک فعال شدند."
})

$BtnStopAll.Add_Click({
    Log-Msg "توقف تمام سرویس‌های هرمس..."
    $stopScript = Join-Path $env:USERPROFILE ".hermes-stack\stop.ps1"
    if (Test-Path $stopScript) {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$stopScript`"" -WindowStyle Hidden -Wait
    } else {
        Stop-ServicePort 8787 "Hermes WebUI"
        Stop-ServicePort 20128 "9Router"
    }
    Update-AllStatuses
    Log-Msg "تمام سرویس‌ها متوقف شدند."
})

# Card 1: Agent
$BtnOpenAgentTerminal.Add_Click({
    Log-Msg "اجرای Hermes Agent در پنجره ترمینال..."
    Start-Process powershell.exe -ArgumentList "-NoExit -Command hermes"
})

$BtnEditAgentConfig.Add_Click({
    $cfg = Join-Path $env:USERPROFILE ".hermes\config.yaml"
    if (Test-Path $cfg) {
        Log-Msg "باز کردن فایل تنظیمات: $cfg"
        Start-Process notepad.exe -ArgumentList "`"$cfg`""
    } else {
        Log-Msg "فایل config.yaml یافت نشد."
    }
})

# Card 2: WebUI
$BtnOpenWebUI.Add_Click({ Open-Url "http://127.0.0.1:8787" })
$BtnStartWebUI.Add_Click({
    Log-Msg "استارت اختصاصی Hermes WebUI..."
    $pythonExe = "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe"
    if (-not (Test-Path $pythonExe)) {
        $pythonExe = "$env:USERPROFILE\hermes-webui\.venv\Scripts\python.exe"
    }
    $env:PYTHONPATH = "$env:USERPROFILE\hermes-webui;$env:LOCALAPPDATA\hermes\hermes-agent"
    Push-Location "$env:USERPROFILE\hermes-webui"
    Start-Process -WindowStyle Hidden -FilePath $pythonExe -ArgumentList "bootstrap.py --no-browser 8787" -WorkingDirectory "$env:USERPROFILE\hermes-webui"
    Pop-Location
    Start-Sleep -Seconds 2
    Update-AllStatuses
})
$BtnStopWebUI.Add_Click({ Stop-ServicePort 8787 "Hermes WebUI" })

# Card 3: 9Router
$BtnOpen9Router.Add_Click({ Open-Url "http://127.0.0.1:20128" })
$BtnStart9Router.Add_Click({
    Log-Msg "استارت اختصاصی 9Router..."
    Start-Process cmd.exe -ArgumentList "/c 9router -p 20128" -WindowStyle Hidden
    Start-Sleep -Seconds 2
    Update-AllStatuses
})
$BtnStop9Router.Add_Click({ Stop-ServicePort 20128 "9Router" })

# Card 4: One-Click Update & Maintenance
$DoUpdateAction = {
    Log-Msg "=== شروع به‌روزرسانی هوشمند استک ==="
    $updateScript = Join-Path $env:USERPROFILE ".hermes-stack\update.ps1"
    if (Test-Path $updateScript) {
        Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -File `"$updateScript`""
    } else {
        Log-Msg "در حال آپدیت 9Router..."
        Start-Process cmd.exe -ArgumentList "/c npm install -g 9router@latest" -Wait -WindowStyle Hidden
        Log-Msg "در حال آپدیت Hermes Agent..."
        & "$env:LOCALAPPDATA\hermes\bin\hermes.exe" update
        Log-Msg "آپدیت پایان یافت."
    }
}
$BtnRunUpdate.Add_Click($DoUpdateAction)
$BtnUpdateMaster.Add_Click($DoUpdateAction)

$BtnOpenHermesDir.Add_Click({
    $dir = "$env:USERPROFILE\.hermes"
    if (Test-Path $dir) { Start-Process explorer.exe -ArgumentList "`"$dir`"" }
})

# Setup auto-refresh timer (every 3 seconds)
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(3)
$timer.Add_Tick({ Update-AllStatuses })
$timer.Start()

# Initial load
Log-Msg "کنترل پنل هرمس با موفقیت لود شد."
Update-AllStatuses

# Show Window
$window.ShowDialog() | Out-Null
$timer.Stop()

