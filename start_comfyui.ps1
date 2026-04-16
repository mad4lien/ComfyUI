# Start ComfyUI in background process (survives SSH disconnection)
# Usage: .\start_comfyui.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$batFile = Join-Path $scriptDir "run_comfyui.bat"

Write-Host "Starting ComfyUI from $batFile"

# Start process detached - survives SSH disconnection
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batFile`"" -WindowStyle Hidden -NoNewWindow

Write-Host "ComfyUI started in background"
Write-Host ""
Write-Host "To check if it's running:"
Write-Host "  Get-Process | Where-Object {`$_.ProcessName -like '*python*'}"
Write-Host ""
Write-Host "To stop it:"
Write-Host "  Stop-Process -Name python -Force"
