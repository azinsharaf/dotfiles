#!/usr/bin/env pwsh

# ── Tab layout (edit here) ─────────────────────────────────────────
$tabsJson = @'
[
  {"name":"1: NVIM/AI","command":"nvim","split":{"direction":"right","command":"pi"}},
  {"name":"2: GIT","command":"lazygit","split":{"direction":"right","command":"tuicr"}},
  {"name":"3: YAZI","command":"yazi"},
  {"name":"4: SQL","command":"sqlit-tui"},
  {"name":"5: BTOP","command":"btop"},
  {"name":"6: RSS","command":""},
  {"name":"7: MUSIC","command":""}
]
'@

function Seed-Tabs ($WorkspaceId) {
    $tabs = $tabsJson | ConvertFrom-Json
    foreach ($tab in $tabs) {
        $resp = herdr tab create --workspace $WorkspaceId --label $tab.name --no-focus 2>$null | ConvertFrom-Json
        $rootPaneId = $resp.result.root_pane.pane_id

        if ($tab.command) {
            herdr pane run $rootPaneId $tab.command >$null 2>&1
        }

        if ($tab.split) {
            $splitResp = herdr pane split --pane $rootPaneId --direction $tab.split.direction --no-focus 2>$null | ConvertFrom-Json
            $newPaneId = $splitResp.result.pane.pane_id
            if ($tab.split.command) {
                herdr pane run $newPaneId $tab.split.command >$null 2>&1
            }
        }
    }
}

# ── Project sources (edit here) ────────────────────────────────────
$homeDir = if ($env:HOME) { $env:HOME } else { $env:USERPROFILE }

$sources = @(
    @{ name="repos"; path="$homeDir\repos"; entries="children" }
    @{ name="chezmoi"; path="$homeDir\.local\share\chezmoi"; entries="self" }
    @{ name="Hydro Viewer 1.17"; path="$homeDir\arcgis-experience-builder-1.17\ArcGISExperienceBuilder_PROD\server\public\apps"; entries="self" }
    @{ name="Hydro Viewer 1.21"; path="$homeDir\arcgis-experience-builder-1.21\ArcGISExperienceBuilder_PROD\server\public\apps"; entries="self" }
    @{ name="Azin Notes Personal"; path="$homeDir\Azin_Notes_Personal"; entries="self" }
    @{ name="Azin Notes Work"; path="$homeDir\OneDrive - Wood Rodgers Inc\Azin_Notes_Work"; entries="self" }
)

# ── Build candidates list ─────────────────────────────────────────
$candidates = @()
foreach ($src in $sources) {
    if (-not (Test-Path $src.path)) { continue }

    if ($src.entries -eq "self") {
        $candidates += [PSCustomObject]@{ label = $src.name; cwd = $src.path }
    } else {
        Get-ChildItem -Path $src.path -Directory | ForEach-Object {
            $candidates += [PSCustomObject]@{ label = "$($src.name)/$($_.Name)"; cwd = $_.FullName }
        }
    }
}

if ($candidates.Count -eq 0) {
    Write-Error "No projects found"
    exit 1
}

# ── Pick via fzf (fall back to Out-GridView) ──────────────────────
$labels = $candidates | ForEach-Object { $_.label } | Sort-Object
$pick = $null
try {
    $pick = $labels | fzf --prompt "project> " --height 20
} catch {
    $pick = $labels | Out-GridView -Title "Pick a project" -OutputMode Single
}

if (-not $pick) { exit 0 }

$chosen = $candidates | Where-Object { $_.label -eq $pick } | Select-Object -First 1
$label = $chosen.label
$cwd = $chosen.cwd

# ── Focus existing or create + seed (silenced) ────────────────────
$workspaces = herdr workspace list 2>$null | ConvertFrom-Json
$existing = $workspaces.result.workspaces | Where-Object { $_.label -eq $label }

if (-not $existing) {
    $resp = herdr workspace create --cwd $cwd --label $label --no-focus 2>$null | ConvertFrom-Json
    $workspaceId = $resp.result.workspace.workspace_id
    $initialTabId = $resp.result.tab.tab_id

    Seed-Tabs $workspaceId

    herdr tab close $initialTabId >$null 2>&1
    herdr workspace focus $workspaceId >$null 2>&1
} else {
    herdr workspace focus $existing[0].workspace_id >$null 2>&1
}
