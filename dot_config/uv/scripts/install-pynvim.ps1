#!/usr/bin/env pwsh
# Rebuilds ~/.venvs/pynvim — the Python env nvim uses for its Python provider.
# Pointed at by ~/.config/nvim/lua/config/globals.lua.tmpl
# Idempotent: safe to re-run.

$ErrorActionPreference = 'Stop'

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    throw "uv is not on PATH. Install with: scoop install main/uv"
}

$venvDir = Join-Path $env:USERPROFILE '.venvs\pynvim'
$pyExe   = Join-Path $venvDir 'Scripts\python.exe'

Write-Host "Creating venv at $venvDir (Python 3.12)..."
uv venv --python 3.12 $venvDir

Write-Host "Installing pynvim + deps..."
& $pyExe -m pip install --upgrade pip
& $pyExe -m pip install `
    'pynvim==0.6.0' `
    'greenlet==3.5.1' `
    'msgpack==1.1.2'

Write-Host ""
Write-Host "Done. nvim is configured to use:"
Write-Host "  $pyExe"
