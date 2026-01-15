# RAT-Blocker

**Endpoint Execution Control for Dispatch & Sales Teams**

RAT-Blocker is a Windows-based security control designed to prevent phishing emails, fake dispatch links, and malicious attachments from installing remote access tools (RATs) on logistics and sales workstations.

It works by enforcing Windows Software Restriction Policies (SRP) to block execution of common malware file types from user-writable directories such as Downloads, Desktop, Temp, and AppData — where most real-world payloads are dropped.

This project is designed for:

- Internal company deployment
- MSP/RMM rollout
- Future commercial productization

---

## Features

- Blocks `.exe`, `.msi`, `.ps1`, `.bat`, `.cmd`, `.vbs`, `.js`, `.hta` from user folders
- One-click GUI enable/disable (admin required)
- Audit-grade Windows Event Log entries
- Webhook-ready logging agent
- Deployment support for:
  - Group Policy (GPO)
  - Microsoft Intune
  - RMM tools (Ninja, Atera, ConnectWise, etc.)

---

## Repo Structure

rat-blocker/

├── core/

│   ├── enable.ps1     # Enables SRP protection

│   ├── disable.ps1    # Disables SRP protection

│   └── status.ps1     # Reports protection status

├── gui/

│   └── rat-blocker.ps1  # Windows Forms GUI

├── logging/

│   └── agent.ps1     # Event log + webhook forwarder

├── deploy/

│   ├── gpo.ps1       # Domain deployment

│   ├── intune.ps1   # Intune Win32 deployment

│   └── rmm.ps1      # RMM deployment

└── README.md

<pre class="overflow-visible! px-0!" data-start="1810" data-end="2139"><div class="contain-inline-size rounded-2xl corner-superellipse/1.1 relative bg-token-sidebar-surface-primary"><div class="sticky top-[calc(--spacing(9)+var(--header-height))] @w-xl/main:top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre!"><span><span>
---

</span><span>## Requirements</span><span>

</span><span>-</span><span></span><span>Windows</span><span></span><span>10</span><span>/11</span><span></span><span>Pro</span><span></span><span>or</span><span></span><span>Enterprise</span><span>
</span><span>-</span><span></span><span>Local</span><span></span><span>admin</span><span></span><span>or</span><span></span><span>SYSTEM</span><span></span><span>privileges</span><span>
</span><span>-</span><span></span><span>PowerShell</span><span></span><span>5.1</span><span>+</span><span>
</span><span>-</span><span></span><span>Group</span><span></span><span>Policy</span><span></span><span>/</span><span></span><span>Intune</span><span></span><span>/</span><span></span><span>RMM</span><span></span><span>access</span><span></span><span>(optional</span><span></span><span>for</span><span></span><span>scale)</span><span>

---

</span><span>## Quick Start (Manual Test)</span><span>

</span><span>1</span><span>.</span><span></span><span>Open</span><span></span><span>PowerShell</span><span></span><span>as</span><span></span><span>Administrator</span><span>
</span><span>2. Run:</span><span>
</span><span>```powershell</span><span>
</span><span>Set-ExecutionPolicy</span><span></span><span>Bypass</span><span></span><span>-Scope</span><span></span><span>Process</span><span>
</span><span>.\core\enable.ps1</span><span>
</span></span></code></div></div></pre>

3. Try downloading an `.exe` into Downloads and running it

   You should see:

> This program is blocked by group policy

---

## Logging

RAT-Blocker writes security events to:

* **Windows Event Log → Application**
* Source: `RAT-Blocker`

The logging agent can forward these events to a webhook for:

* Slack
* Teams
* SIEM
* Internal dashboards

---

## Deployment

### GPO

Use `deploy/gpo.ps1` to apply policy domain-wide.

### Intune

Use `deploy/intune.ps1` as a Win32 app install script.

### RMM

Use `deploy/rmm.ps1` for silent deployment via RMM tools.

---

## Legal Notice

This software enforces execution restrictions that may block legitimate installers, updates, and scripts.

Use at your own risk. Test before wide deployment. Always maintain an admin override process.

---

## Roadmap

* Background watchdog service
* Temporary unlock workflow
* Central management dashboard
* AppLocker integration
* Signed installer and tamper protection

---

## License

Internal use. Commercial licensing TBD.

<pre class="overflow-visible! px-0!" data-start="3153" data-end="4262"><div class="contain-inline-size rounded-2xl corner-superellipse/1.1 relative bg-token-sidebar-surface-primary"><div class="sticky top-[calc(--spacing(9)+var(--header-height))] @w-xl/main:top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre!"><span><span>
</span><span>---</span><span>

</span><span># 2) `logging/agent.ps1`  </span><span>
**Event Log → Webhook Forwarder**

This runs as a scheduled task or background </span><span>process</span><span>.

```powershell
</span><span># RAT-Blocker Logging Agent</span><span>
</span><span># Forwards Windows Event Log entries to a webhook endpoint</span><span>

</span><span>$WebhookUrl</span><span> = </span><span>"https://your-webhook-endpoint-here"</span><span>
</span><span>$Source</span><span> = </span><span>"RAT-Blocker"</span><span>

</span><span>Write-Host</span><span></span><span>"RAT-Blocker Logging Agent Started..."</span><span>

</span><span>$LastRun</span><span> = </span><span>Get-Date</span><span>

</span><span>while</span><span> (</span><span>$true</span><span>) {
    </span><span>Start-Sleep</span><span></span><span>-Seconds</span><span></span><span>30</span><span>

    </span><span>$Events</span><span> = </span><span>Get-WinEvent</span><span></span><span>-FilterHashtable</span><span></span><span>@</span><span>{
        LogName = </span><span>"Application"</span><span>
        ProviderName = </span><span>$Source</span><span>
        StartTime = </span><span>$LastRun</span><span>
    } </span><span>-ErrorAction</span><span> SilentlyContinue

    </span><span>foreach</span><span> (</span><span>$Event</span><span></span><span>in</span><span></span><span>$Events</span><span>) {
        </span><span>$Payload</span><span> = </span><span>@</span><span>{
            machine = </span><span>$env:COMPUTERNAME</span><span>
            user    = </span><span>$env:USERNAME</span><span>
            time    = </span><span>$Event</span><span>.TimeCreated
            eventId = </span><span>$Event</span><span>.Id
            message = </span><span>$Event</span><span>.Message
        } | </span><span>ConvertTo-Json</span><span></span><span>-Depth</span><span></span><span>3</span><span>

        </span><span>try</span><span> {
            </span><span>Invoke-RestMethod</span><span></span><span>-Uri</span><span></span><span>$WebhookUrl</span><span></span><span>-Method</span><span> POST </span><span>-Body</span><span></span><span>$Payload</span><span></span><span>-ContentType</span><span></span><span>"application/json"</span><span>
        } </span><span>catch</span><span> {
            </span><span>Write-Host</span><span></span><span>"Failed to send webhook"</span><span>
        }
    }

    </span><span>$LastRun</span><span> = </span><span>Get-Date</span><span>
}
</span></span></code></div></div></pre>

---

# 3) `deploy/gpo.ps1`

**Domain Deployment (Run as Domain Admin)**

<pre class="overflow-visible! px-0!" data-start="4338" data-end="4756"><div class="contain-inline-size rounded-2xl corner-superellipse/1.1 relative bg-token-sidebar-surface-primary"><div class="sticky top-[calc(--spacing(9)+var(--header-height))] @w-xl/main:top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-powershell"><span><span>Write-Host</span><span></span><span>"Deploying RAT-Blocker via GPO..."</span><span>

</span><span>$Target</span><span> = </span><span>"\\DOMAIN-SYSVOL\RAT-Blocker"</span><span>

</span><span>if</span><span> (</span><span>-not</span><span> (</span><span>Test-Path</span><span></span><span>$Target</span><span>)) {
    </span><span>New-Item</span><span></span><span>-ItemType</span><span> Directory </span><span>-Path</span><span></span><span>$Target</span><span> | </span><span>Out-Null</span><span>
}

</span><span>Copy-Item</span><span></span><span>"..\core"</span><span></span><span>$Target</span><span></span><span>-Recurse</span><span></span><span>-Force</span><span>
</span><span>Copy-Item</span><span></span><span>"..\logging"</span><span></span><span>$Target</span><span></span><span>-Recurse</span><span></span><span>-Force</span><span>

</span><span>Write-Host</span><span></span><span>"Files copied to SYSVOL."</span><span>
</span><span>Write-Host</span><span></span><span>"Create a startup script GPO pointing to:"</span><span>
</span><span>Write-Host</span><span></span><span>"$Target</span><span>\core\enable.ps1"
</span></span></code></div></div></pre>

---

# 4) `deploy/intune.ps1`

**Win32 App Install Script**

This is what Intune runs on install.

<pre class="overflow-visible! px-0!" data-start="4858" data-end="5374"><div class="contain-inline-size rounded-2xl corner-superellipse/1.1 relative bg-token-sidebar-surface-primary"><div class="sticky top-[calc(--spacing(9)+var(--header-height))] @w-xl/main:top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-powershell"><span><span>Write-Host</span><span></span><span>"Installing RAT-Blocker via Intune..."</span><span>

</span><span>$InstallPath</span><span> = </span><span>"C:\Program Files\RAT-Blocker"</span><span>

</span><span>if</span><span> (</span><span>-not</span><span> (</span><span>Test-Path</span><span></span><span>$InstallPath</span><span>)) {
    </span><span>New-Item</span><span></span><span>-ItemType</span><span> Directory </span><span>-Path</span><span></span><span>$InstallPath</span><span> | </span><span>Out-Null</span><span>
}

</span><span>Copy-Item</span><span></span><span>".\core"</span><span></span><span>$InstallPath</span><span></span><span>-Recurse</span><span></span><span>-Force</span><span>
</span><span>Copy-Item</span><span></span><span>".\logging"</span><span></span><span>$InstallPath</span><span></span><span>-Recurse</span><span></span><span>-Force</span><span>
</span><span>Copy-Item</span><span></span><span>".\gui"</span><span></span><span>$InstallPath</span><span></span><span>-Recurse</span><span></span><span>-Force</span><span>

</span><span>Start-Process</span><span> powershell </span><span>"-ExecutionPolicy Bypass -File `"$InstallPath</span><span>\core\enable.ps1`"" </span><span>-Verb</span><span> RunAs

</span><span>Write-Host</span><span></span><span>"RAT-Blocker installed and enabled."</span><span>
</span></span></code></div></div></pre>

---

# 5) `deploy/rmm.ps1`

**RMM Silent Install**

Designed for Ninja, Atera, CW Automate, etc.

<pre class="overflow-visible! px-0!" data-start="5475" data-end="5887"><div class="contain-inline-size rounded-2xl corner-superellipse/1.1 relative bg-token-sidebar-surface-primary"><div class="sticky top-[calc(--spacing(9)+var(--header-height))] @w-xl/main:top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-bg-elevated-secondary text-token-text-secondary flex items-center gap-4 rounded-sm px-2 font-sans text-xs"></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-powershell"><span><span>Write-Host</span><span></span><span>"RMM Deploy: RAT-Blocker"</span><span>

</span><span>$InstallPath</span><span> = </span><span>"C:\Program Files\RAT-Blocker"</span><span>

</span><span>if</span><span> (</span><span>-not</span><span> (</span><span>Test-Path</span><span></span><span>$InstallPath</span><span>)) {
    </span><span>New-Item</span><span></span><span>-ItemType</span><span> Directory </span><span>-Path</span><span></span><span>$InstallPath</span><span> | </span><span>Out-Null</span><span>
}

</span><span>Copy-Item</span><span></span><span>".\core"</span><span></span><span>$InstallPath</span><span></span><span>-Recurse</span><span></span><span>-Force</span><span>
</span><span>Copy-Item</span><span></span><span>".\logging"</span><span></span><span>$InstallPath</span><span></span><span>-Recurse</span><span></span><span>-Force</span><span>

powershell </span><span>-ExecutionPolicy</span><span> Bypass </span><span>-File</span><span></span><span>"$InstallPath</span><span>\core\enable.ps1"

</span><span>Write-Host</span><span></span><span>"Deployment complete."</span><span>
</span></span></code></div></div></pre>
