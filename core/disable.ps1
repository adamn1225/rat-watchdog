# RAT Blocker - Disable Script
# This script disables RAT blocking functionality

[CmdletBinding()]
param()

Write-Host "Disabling RAT Blocker..." -ForegroundColor Yellow

# Add your disable logic here
$baseKey = "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
Remove-Item -Path $baseKey -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Protection disabled. Log out and back in."
