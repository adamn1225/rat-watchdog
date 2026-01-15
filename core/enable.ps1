$User = $env:USERNAME
$Machine = $env:COMPUTERNAME
$Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-EventLog -LogName Application -Source "RAT-Blocker" -EventId 1001 -EntryType Information -Message "Protection ENABLED by $User on $Machine at $Time"


[CmdletBinding()]
param()

Write-Host "Enabling RAT Blocker..." -ForegroundColor Green

# Add your enabling logic here
Write-Host "Blocking executable files from user folders..."

$baseKey = "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers"

# Enable SRP
New-Item -Path $baseKey -Force | Out-Null
Set-ItemProperty -Path $baseKey -Name "DefaultLevel" -Value 262144
Set-ItemProperty -Path $baseKey -Name "PolicyScope" -Value 0
Set-ItemProperty -Path $baseKey -Name "TransparentEnabled" -Value 1

# Create path rules
$paths = @(
    "%USERPROFILE%\Downloads\*",
    "%USERPROFILE%\Desktop\*",
    "%USERPROFILE%\AppData\Local\Temp\*",
    "%USERPROFILE%\AppData\Roaming\*"
)

foreach ($path in $paths) {
    $ruleKey = "$baseKey\Paths\" + [guid]::NewGuid().ToString()
    New-Item -Path $ruleKey -Force | Out-Null
    Set-ItemProperty -Path $ruleKey -Name "ItemData" -Value $path
    Set-ItemProperty -Path $ruleKey -Name "SaferFlags" -Value 0
    Set-ItemProperty -Path $ruleKey -Name "Description" -Value "Blocked user execution path"
}

Write-Host "Done. Executables can no longer run from Downloads, Desktop, or Temp."
Write-Host "Log out and back in for full effect."
