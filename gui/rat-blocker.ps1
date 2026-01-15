Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "RAT Protection Control"
$form.Size = "300,200"
$form.StartPosition = "CenterScreen"

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = "50,20"
$statusLabel.Size = "200,30"

$enableBtn = New-Object System.Windows.Forms.Button
$enableBtn.Text = "Enable Protection"
$enableBtn.Location = "50,60"
$enableBtn.Size = "180,30"

$disableBtn = New-Object System.Windows.Forms.Button
$disableBtn.Text = "Disable Protection"
$disableBtn.Location = "50,100"
$disableBtn.Size = "180,30"

function Get-Status {
    if (Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers") {
        $statusLabel.Text = "Status: ENABLED"
    } else {
        $statusLabel.Text = "Status: DISABLED"
    }
}

$enableBtn.Add_Click({
    Start-Process powershell "-ExecutionPolicy Bypass -File enable.ps1" -Verb RunAs
    Start-Sleep 2
    Get-Status
})

$disableBtn.Add_Click({
    Start-Process powershell "-ExecutionPolicy Bypass -File disable.ps1" -Verb RunAs
    Start-Sleep 2
    Get-Status
})

$form.Controls.Add($statusLabel)
$form.Controls.Add($enableBtn)
$form.Controls.Add($disableBtn)

Get-Status
$form.ShowDialog()
