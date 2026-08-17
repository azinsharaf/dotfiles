#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Manage the scoop apps listed in this repo's README.

.DESCRIPTION
    The single source of truth is the $scoopApps array below. Running this
    script with no parameters installs any packages that aren't already
    present. -SyncReadme rewrites the "Scoop Apps" section of README.md from
    $scoopApps (and $ghExtensions). Edit the arrays, then run -SyncReadme to
    publish the change.

.PARAMETER Force
    Re-install apps even if they are already present.

.PARAMETER DryRun
    Print the commands that would run, but do not execute them.

.PARAMETER SyncReadme
    Overwrite the "Scoop Apps" section of README.md with the contents of
    $scoopApps / $ghExtensions.

.EXAMPLE
    pwsh ./scripts/install-scoop-apps.ps1
.EXAMPLE
    pwsh ./scripts/install-scoop-apps.ps1 -DryRun
.EXAMPLE
    pwsh ./scripts/install-scoop-apps.ps1 -SyncReadme
#>

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$DryRun,
    [switch]$SyncReadme
)

$ErrorActionPreference = 'Stop'

# -----------------------------------------------------------------------------
# Single source of truth. Add, remove, or reorder entries here, then run
# `-SyncReadme` to refresh README.md.
#
# `Spec` is the value passed to `scoop install` (so it may be prefixed with a
# bucket, e.g. "extras/qmk-toolbox"). `Note` is the trailing comment that
# appears in the README.
# -----------------------------------------------------------------------------

$scoopApps = @(
    @{ Spec = 'autohotkey';                  Note = 'Scripting language for Windows automation' },
    @{ Spec = 'bat';                         Note = 'A cat clone with syntax highlighting' },
    @{ Spec = 'bitwarden';                   Note = 'Password manager' },
    @{ Spec = 'bitwarden-cli';               Note = 'Command-line interface for Bitwarden' },
    @{ Spec = 'broot';                       Note = 'A new way to see and navigate directory trees' },
    @{ Spec = 'btop-lhm';                    Note = 'Resource monitor' },
    @{ Spec = 'chafa';                       Note = 'Terminal graphics for the 21st century' },
    @{ Spec = 'chezmoi';                     Note = 'Manage your dotfiles across multiple machines' },
    @{ Spec = 'clipboard';                   Note = 'Clipboard manager' },
    @{ Spec = 'discord';                     Note = 'Voice and text chat for gamers' },
    @{ Spec = 'dust';                        Note = 'More intuitive version of du in rust' },
    @{ Spec = 'eza';                         Note = 'Modern replacement for ls' },
    @{ Spec = 'extras/qmk-toolbox';          Note = 'QMK Firmware flashing tool' },
    @{ Spec = 'extras/via';                  Note = 'VIA configurator for keyboards' },
    @{ Spec = 'fd';                          Note = 'Simple, fast, and user-friendly alternative to find' },
    @{ Spec = 'ffmpeg';                      Note = 'Multimedia framework' },
    @{ Spec = 'flow-launcher';               Note = 'Productivity tool to quickly search and launch' },
    @{ Spec = 'fzf';                         Note = 'Command-line fuzzy finder' },
    @{ Spec = 'gh';                          Note = "GitHub's official command line tool" },
    @{ Spec = 'glow';                        Note = 'Render markdown on the CLI' },
    @{ Spec = 'greenshot';                   Note = 'Screenshot tool' },
    @{ Spec = 'hexyl';                       Note = 'A command-line hex viewer' },
    @{ Spec = 'imagemagick';                 Note = 'Image processing tools' },
    @{ Spec = 'jq';                          Note = 'Command-line JSON processor' },
    @{ Spec = 'keepass';                     Note = 'Password manager' },
    @{ Spec = 'keyviz';                      Note = 'Keypress visualizer' },
    @{ Spec = 'lazygit';                     Note = 'Simple terminal UI for git commands' },
    @{ Spec = 'lsd';                         Note = 'The next gen ls command' },
    @{ Spec = 'luarocks';                    Note = 'Package manager for Lua modules' },
    @{ Spec = 'make';                        Note = 'Utility for directing compilation' },
    @{ Spec = 'gcc';                         Note = 'GNU C/C++ compiler toolchain' },
    @{ Spec = 'main/7zip';                   Note = 'File archiver with a high compression ratio' },
    @{ Spec = 'main/unzip';                  Note = 'Unzip compression utility' },
    @{ Spec = 'main/gzip';                   Note = 'Popular data compression utility' },
    @{ Spec = 'motrix';                      Note = 'Full-featured download manager' },
    @{ Spec = 'nerd-fonts/JetBrainsMono-NF'; Note = 'JetBrainsMono Nerd Font' },
    @{ Spec = 'nerd-fonts/JetBrainsMono-NF-Propo'; Note = 'JetBrainsMono Nerd Font Propo' },
    @{ Spec = 'neovim-nightly';              Note = 'Hyperextensible Vim-based text editor' },
    @{ Spec = 'nodejs-lts';                  Note = "JavaScript runtime built on Chrome's V8" },
    @{ Spec = 'nonportable/files-np';        Note = 'File manager' },
    @{ Spec = 'notepadplusplus';             Note = 'Text editor' },
    @{ Spec = 'obsidian';                    Note = 'Knowledge base that works on top of a local folder of plain text Markdown files' },
    @{ Spec = 'pandoc';                      Note = 'Universal document converter' },
    @{ Spec = 'poppler';                     Note = 'PDF rendering library' },
    @{ Spec = 'pwsh';                        Note = 'PowerShell Core' },
    @{ Spec = 'qutebrowser';                 Note = 'A keyboard-driven, vim-like browser' },
    @{ Spec = 'extras/zen-browser';          Note = 'Zen Browser' },
    @{ Spec = 'ripgrep';                     Note = 'Line-oriented search tool' },
    @{ Spec = 'grep';                        Note = 'Line-oriented search tool' },
    @{ Spec = 'speedtest-cli';               Note = 'Internet speed testing from the command line' },
    @{ Spec = 'spotify';                     Note = 'Music streaming service' },
    @{ Spec = 'spotify-player';              Note = 'Command-line Spotify client' },
    @{ Spec = 'starship';                    Note = 'The minimal, blazing-fast, and infinitely customizable prompt for any shell' },
    @{ Spec = 'thunderbird';                 Note = 'Email client' },
    @{ Spec = 'treesize-free';               Note = 'Disk space analyzer' },
    @{ Spec = 'tree-sitter';                 Note = 'Incremental parsing system for programming tools' },
    @{ Spec = 'uutils-coreutils';            Note = 'Cross-platform Rust rewrite of the GNU coreutils' },
    @{ Spec = 'wezterm-nightly';             Note = 'GPU-accelerated terminal emulator' },
    @{ Spec = 'yt-dlp';                      Note = 'A youtube-dl fork with additional features' },
    @{ Spec = 'zoom';                        Note = 'Video conferencing tool' },
    @{ Spec = 'zoxide';                      Note = 'A smarter cd command' },
    @{ Spec = 'dua';                         Note = 'Disk usage analyzer' },
    @{ Spec = 'exiftool';                    Note = 'Get the metadata of pictures' },
    @{ Spec = 'mediainfo';                   Note = 'Get the metadata of videos' },
    @{ Spec = 'less';                        Note = 'Terminal pager' },
    @{ Spec = 'extras/opencode';             Note = 'AI coding agent' },
    @{ Spec = 'main/uutils-coreutils';       Note = 'Rust implementation of GNU coreutils (binaries compiled with MSVC)' },
    @{ Spec = 'extras/psfzf';                Note = 'Powershell wrapper around the fuzzy finder fzf' },
    @{ Spec = 'extras/psreadline';           Note = 'A bash inspired readline implementation for PowerShell' },
    @{ Spec = 'go';                          Note = 'Go programming language' },
    @{ Spec = 'main/witr';                   Note = 'Why is this running?' },
    @{ Spec = 'main/uv';                     Note = 'Python package manager' },
    @{ Spec = 'extras/altsnap';              Note = 'Windows snapping alternative' },
    @{ Spec = 'aws';                         Note = 'AWS CLI' },
    @{ Spec = 'azure-cli';                   Note = 'Azure CLI' },
    @{ Spec = 'extras/carapace-bin';         Note = 'Multi-shell argument completer' },
    @{ Spec = 'extras/Cyberduck';            Note = 'FTP/SFTP/WebDAV client' },
    @{ Spec = 'fastfetch';                   Note = 'System info tool' },
    @{ Spec = 'git';                         Note = 'Git version control' },
    @{ Spec = 'glazewm';                     Note = 'Tiling window manager' },
    @{ Spec = 'extras/lazysql';              Note = 'Lazy TUI for SQL databases' },
    @{ Spec = 'lua';                         Note = 'Lua interpreter' },
    @{ Spec = 'extras/miniconda3';           Note = 'Minimal conda installer' },
    @{ Spec = 'extras/mpv';                  Note = 'Media player' },
    @{ Spec = 'ncspot';                      Note = 'ncurses Spotify client' },
    @{ Spec = 'nu';                          Note = 'nushell shell' },
    @{ Spec = 'extras/pdfgear';              Note = 'PDF editor' },
    @{ Spec = 'perl';                        Note = 'Perl interpreter' },
    @{ Spec = 'extras/postman';              Note = 'API development environment' },
    @{ Spec = 'python';                      Note = 'Python interpreter' },
    @{ Spec = 'stylua';                      Note = 'Lua code formatter' },
    @{ Spec = 'extras/television';           Note = 'Fuzzy finder for the terminal' },
    @{ Spec = 'usql';                        Note = 'Universal SQL client' },
    @{ Spec = 'extras/vscode';               Note = 'Visual Studio Code' },
    @{ Spec = 'extras/win-vind';             Note = 'Vim-like keybindings for Windows' },
    @{ Spec = 'xdagiz/xytz';                 Note = 'Timezone converter' },
    @{ Spec = 'extras/yasb';                 Note = 'Status bar for Windows' },
    @{ Spec = 'versions/yazi-nightly';       Note = 'Terminal file manager (nightly)' },
    @{ Spec = 'zellij';                      Note = 'Terminal multiplexer' }
    @{ Spec = 'llmfit';                      Note = 'Check hardware to host local llm' }
)

$ghExtensions = @(
    @{ Spec = 'dlvhdr/gh-dash'; Note = 'Interactive GitHub dashboard for the terminal' }
)

# -----------------------------------------------------------------------------
# Path helpers
# -----------------------------------------------------------------------------

$scriptDir  = Split-Path -Parent $PSCommandPath
$ReadmePath = Join-Path $scriptDir '..\README.md'

# -----------------------------------------------------------------------------
# -SyncReadme: rewrite the Scoop Apps section of README.md from the arrays.
# -----------------------------------------------------------------------------

function Sync-Readme {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path
    )

    $lines = Get-Content -LiteralPath $Path

    $startIdx = -1
    $endIdx   = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($startIdx -lt 0 -and $lines[$i] -match '^####\s+Scoop Apps\s*$') {
            $startIdx = $i
            continue
        }
        if ($startIdx -ge 0 -and $lines[$i] -match '^####\s+') {
            $endIdx = $i
            break
        }
    }

    if ($startIdx -lt 0) {
        throw "Could not find a '#### Scoop Apps' heading in $Path"
    }
    if ($endIdx -lt 0) {
        throw "Could not find a following '####' heading after Scoop Apps in $Path"
    }

    $newBlock = New-ScoopAppsBlock -ScoopApps $scoopApps -GhExtensions $ghExtensions

    # Preserve trailing newline behaviour of Get-Content.
    $before = $lines[0..($startIdx - 1)]
    $after  = if ($endIdx -lt $lines.Count) { $lines[$endIdx..($lines.Count - 1)] } else { @() }
    $merged = @($before) + @($newBlock) + @($after)

    Set-Content -LiteralPath $Path -Value $merged -NoNewline:$false
    Write-Host "Updated $Path ($startIdx..$($endIdx - 1) replaced)" -ForegroundColor Green
    Write-Host ("  -> {0} scoop apps, {1} gh extension(s)" -f $scoopApps.Count, $ghExtensions.Count)
}

function New-ScoopAppsBlock {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object[]]$ScoopApps,
        [Parameter(Mandatory)][object[]]$GhExtensions
    )

    $out = New-Object System.Collections.Generic.List[string]
    [void]$out.Add('#### Scoop Apps')
    [void]$out.Add('')
    [void]$out.Add('```shell')
    foreach ($a in $ScoopApps) {
        [void]$out.Add(("scoop install {0} # {1}" -f $a.Spec, $a.Note))
    }
    foreach ($g in $GhExtensions) {
        [void]$out.Add(("gh extension install {0} # {1}" -f $g.Spec, $g.Note))
    }
    [void]$out.Add('```')
    return ,$out.ToArray()
}

if ($SyncReadme) {
    $ReadmePath = (Resolve-Path -LiteralPath $ReadmePath -ErrorAction Stop).Path
    Sync-Readme -Path $ReadmePath
    return
}

# -----------------------------------------------------------------------------
# Install mode
# -----------------------------------------------------------------------------

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    throw "Scoop is not installed. Install it first: https://scoop.sh"
}

# Collect the list of specs.
$appList = @($scoopApps | ForEach-Object { $_.Spec })

Write-Host ("Found {0} scoop apps and {1} gh extension(s)" -f $appList.Count, $ghExtensions.Count) `
    -ForegroundColor Cyan

# Resolve which are already installed.
$installed = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase)

if (-not $Force) {
    Write-Host "Querying installed apps..." -ForegroundColor Cyan
    $raw = scoop list 2>&1 | Out-String
    if ($LASTEXITCODE -eq 0 -and $raw) {
        $ansi = [regex]'\x1B\[[0-?]*[ -/]*[@-~]'
        $clean = ($raw -split "`r?`n") | ForEach-Object { $ansi.Replace($_, '') }
        foreach ($row in ($clean | Select-Object -Skip 4)) {
            if ($row -match '^\s*(\S+)') {
                [void]$installed.Add($Matches[1])
            }
        }
    } else {
        Write-Warning "`scoop list` failed; will not skip installed apps."
    }
}

function Test-Installed([string]$pkgSpec) {
    $name = ($pkgSpec -split '/')[-1]
    return $installed.Contains($name)
}

$toInstall = @()
foreach ($pkg in $appList) {
    if ((-not $Force) -and (Test-Installed $pkg)) {
        Write-Verbose "Skip: $pkg (already installed)"
    } else {
        $toInstall += $pkg
    }
}

if ($toInstall.Count -gt 0) {
    Write-Host ""
    Write-Host ("Installing {0} app(s):" -f $toInstall.Count) -ForegroundColor Cyan
    $toInstall | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""

    if ($DryRun) { return }

    $failed = @()
    foreach ($pkg in $toInstall) {
        Write-Host ">>> scoop install $pkg" -ForegroundColor Cyan
        scoop install $pkg
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to install: $pkg"
            $failed += $pkg
        }
    }

    if ($failed.Count -gt 0) {
        Write-Host ""
        Write-Host ("{0} install(s) failed:" -f $failed.Count) -ForegroundColor Red
        $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    }
} else {
    Write-Host ""
    Write-Host "All scoop apps already installed." -ForegroundColor Green
}

if (-not $DryRun -and $ghExtensions.Count -gt 0) {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Warning "`gh` not found; skipping gh extension installs."
    } else {
        foreach ($g in $ghExtensions) {
            Write-Host ""
            Write-Host ">>> gh extension install $($g.Spec)" -ForegroundColor Cyan
            gh extension install $g.Spec
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "Failed to install gh extension: $($g.Spec)"
            }
        }
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
