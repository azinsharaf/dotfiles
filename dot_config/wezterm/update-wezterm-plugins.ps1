# Update all git-based plugins in WezTerm's plugins directory

# Set your plugin directory. Modify this if your config is elsewhere
$pluginDir = "$env:USERPROFILE\AppData\Roaming\wezterm\plugins"

# Verify git is in PATH
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: git not found in PATH!" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $pluginDir)) {
    Write-Host "ERROR: Plugin directory not found: $pluginDir" -ForegroundColor Red
    exit 1
}

# Loop through each subdirectory and update if it's a git repo
Get-ChildItem -Path $pluginDir -Directory | ForEach-Object {
    $repo = $_.FullName
    if (Test-Path (Join-Path $repo ".git")) {
        Write-Host "`n==== Updating $($_.Name) ====" -ForegroundColor Cyan
        Push-Location $repo
        git pull
        Pop-Location
    }
}

Write-Host "`nAll done!" -ForegroundColor Green
