# Manage ComfyUI processes
# Usage: .\manage_comfyui.ps1 [start|stop|status]

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("start", "stop", "status", "restart")]
    [string]$Action = "status"
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$startScript = Join-Path $scriptDir "start_comfyui.ps1"

function Get-ComfyUIProcess {
    Get-Process | Where-Object {
        $_.ProcessName -like 'python*' -and $_.CommandLine -like '*main.py*'
    }
}

switch ($Action) {
    "start" {
        $existing = Get-ComfyUIProcess
        if ($existing) {
            Write-Host "ComfyUI is already running (PID: $($existing.Id))"
        } else {
            Write-Host "Starting ComfyUI..."
            & $startScript
        }
    }
    
    "stop" {
        $process = Get-ComfyUIProcess
        if ($process) {
            Write-Host "Stopping ComfyUI (PID: $($process.Id))..."
            Stop-Process -InputObject $process -Force
            Write-Host "ComfyUI stopped"
        } else {
            Write-Host "ComfyUI is not running"
        }
    }
    
    "restart" {
        & $MyInvocation.MyCommand.Path -Action "stop"
        Start-Sleep -Seconds 2
        & $MyInvocation.MyCommand.Path -Action "start"
    }
    
    "status" {
        $process = Get-ComfyUIProcess
        if ($process) {
            Write-Host "ComfyUI is RUNNING"
            Write-Host "  PID: $($process.Id)"
            Write-Host "  Memory: $([math]::Round($process.WorkingSet / 1MB)) MB"
            Write-Host "  Started: $($process.StartTime)"
        } else {
            Write-Host "ComfyUI is NOT running"
        }
    }
}
