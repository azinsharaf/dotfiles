#!/usr/bin/env pwsh

$statePath = if ($env:HOME) { "$env:HOME/.cache/herdr/tab-toggle.json" } else { "$env:USERPROFILE/.cache/herdr/tab-toggle.json" }
$stateDir = Split-Path $statePath -Parent
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null

$snap = herdr api snapshot | ConvertFrom-Json
$now = $snap.result.snapshot.focused_tab_id

if (-not $now) { return }

$last = $null
if (Test-Path $statePath) {
    try {
        $last = (Get-Content $statePath | ConvertFrom-Json).last_tab_id
    } catch { }
}

$lastExists = $false
if ($last) {
    $tabs = herdr tab list | ConvertFrom-Json
    $match = $tabs.result.tabs | Where-Object { $_.tab_id -eq $last }
    if ($match) { $lastExists = $true }
}

if ($lastExists -and ($last -ne $now)) {
    herdr tab focus $last | Out-Null
}

@{ last_tab_id = $now } | ConvertTo-Json | Set-Content $statePath
