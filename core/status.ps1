# RAT Blocker - Status Script
# This script checks the current status of RAT blocking

[CmdletBinding()]
param()

Write-Host "Checking RAT Blocker Status..." -ForegroundColor Cyan

# Add your status check logic here
$baseKey = "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
if (Test-Path $baseKey) {
    Write-Host "RAT Protection: ENABLED"
} else {
    Write-Host "RAT Protection: DISABLED"
}
