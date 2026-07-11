#!/usr/bin/env pwsh
# Rebuilds ~/.venvs/obsidian_terminal — the Python env required by the
# Obsidian "obsidian_terminal" plugin (Windows automation libs).
# Idempotent: safe to re-run.

$ErrorActionPreference = 'Stop'

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    throw "uv is not on PATH. Install with: scoop install main/uv"
}

$venvDir = Join-Path $env:USERPROFILE '.venvs\obsidian_terminal'
$pyExe   = Join-Path $venvDir 'Scripts\python.exe'

Write-Host "Creating venv at $venvDir (Python 3.11)..."
uv venv --python 3.11 $venvDir

Write-Host "Installing plugin dependencies..."
& $pyExe -m pip install --upgrade pip
& $pyExe -m pip install `
    'psutil>=5.9.5' `
    'pywinctl>=0.0.50' `
    'typing-extensions>=4.7.1'

Write-Host ""
Write-Host "Done. Point your Obsidian plugin at:"
Write-Host "  $pyExe"
