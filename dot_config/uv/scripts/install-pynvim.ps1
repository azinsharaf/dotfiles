#!/usr/bin/env pwsh
# Rebuilds ~/.venvs/pynvim — the Python env nvim uses for its Python provider.
# Pointed at by ~/.config/nvim/lua/config/globals.lua.tmpl
# Idempotent: --clear wipes any prior venv so re-runs produce a clean install.

$ErrorActionPreference = 'Stop'

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    throw "uv is not on PATH. Install with: scoop install main/uv"
}

$venvDir = Join-Path $env:USERPROFILE '.venvs\pynvim'
$pyExe   = Join-Path $venvDir 'Scripts\python.exe'

Write-Host "Recreating venv at $venvDir (Python 3.12)..."
uv venv --python 3.12 --clear $venvDir

Write-Host "Installing pynvim + deps..."
uv pip install --python $pyExe `
    'pynvim==0.6.0' `
    'greenlet==3.5.1' `
    'msgpack==1.1.2'

Write-Host ""
Write-Host "Done. nvim is configured to use:"
Write-Host "  $pyExe"
