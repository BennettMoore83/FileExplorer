<#
.SYNOPSIS
    Clears stale network drive caches from the user's registry and restarts Explorer.
    No Admin rights required as it targets HKCU.
#>

# $DriveLetter = "J" # You can change this if other letters appear

Write-Host "Searching for phantom $DriveLetter drive entries..." -ForegroundColor Cyan

# 1. Clear MountPoints2 (The primary culprit for the 'Disconnected' ghost)
$MountPointsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2"
if (Test-Path $MountPointsPath) {
    Get-ChildItem $MountPointsPath | Where-Object { $_.Name -match "\{[a-z0-9-]{36}\}" } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✓ Cleared MountPoints2 cache." -ForegroundColor Green
}

<# 2. Clear standard Network Map key (even if it looks empty in Regedit)
$NetworkPath = "HKCU:\Network\$DriveLetter"
if (Test-Path $NetworkPath) {
    Remove-Item $NetworkPath -Force -Recurse
    Write-Host "✓ Removed HKCU\Network\$DriveLetter key." -ForegroundColor Green
}#>

# 3. Restart Explorer to refresh the shell
Write-Host "Restarting Explorer to apply changes..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force
Start-Process explorer.exe
