# User config
$REPO_ROOT = Join-Path -Path $env:USERPROFILE -ChildPath "repos"

# Ensure tuios is on PATH
function Ensure-Tuios {
    if (-not (Get-Command "tuios" -ErrorAction SilentlyContinue)) {
        Write-Error "tuios not found in PATH. Install and/or adjust PATH."
        exit 1
    }
}

Ensure-Tuios

# Step 1: repo and projects
if (-not (Test-Path -Path $REPO_ROOT)) {
    Write-Error "Repo root '$REPO_ROOT' does not exist."
    exit 1
}

$projects = Get-ChildItem -Directory -Path $REPO_ROOT | Select-Object -ExpandProperty Name
if (-not $projects -or $projects.Count -eq 0) {
    Write-Error "No projects found under '$REPO_ROOT'."
    exit 1
}

Write-Host "Available projects under ${REPO_ROOT}:"
for ($i = 0; $i -lt $projects.Count; $i++) {
    Write-Host ("[{0}] {1}" -f ($i + 1), $projects[$i])
}

# Step 2: pick a project (simple prompt)
$sel = Read-Host "Enter number of project to open (or Q to quit)"
if ($sel -match "^[qQ]$") { exit 0 }

[int]$idx = 0
if (-not [int]::TryParse($sel, [ref]$idx)) {
    Write-Host "Invalid selection (not a number)"
    exit 1
}

$idx = $idx - 1
if ($idx -lt 0 -or $idx -ge $projects.Count) { Write-Host "Invalid index"; exit 1 }
$project = $projects[$idx]
$sessionName = $project

Write-Host "Selected project: $project"
Write-Host "Session name: $sessionName"

# Step 3: attach-or-create a TUIOS session for this project
$tuiosSession = $sessionName
Write-Host "Attaching to TUIOS session '$tuiosSession' (detach with Ctrl+a, then d to keep the session running)..."
tuios attach $tuiosSession -c
