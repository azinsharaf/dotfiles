# Set-PSReadlineOption -EditMode vi -viModeIndicator Cursor
# Enabling Menu Completion 
# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Conda (ArcGIS Pro) activator: ca [envname]
function ca
{
    param([string]$Name = 'arcgispro-py3-clone')

    $root = 'C:\Program Files\ArcGIS\Pro\bin\Python'
    $condaExe = Join-Path $root 'Scripts\conda.exe'
    $psm1     = Join-Path $root 'shell\condabin\Conda.psm1'

    if (-not (Test-Path -LiteralPath $psm1))
    {
        Write-Warning "Conda.psm1 not found at: $psm1"
        return
    }
    if (-not (Test-Path -LiteralPath $condaExe))
    {
        Write-Warning "conda.exe not found at: $condaExe"
        return
    }

    try
    {
        # prevent conda from altering the prompt
        $Env:CONDA_CHANGEPS1 = "false"

        $Env:_CONDA_ROOT = $root
        $Env:_CONDA_EXE  = $condaExe
        $Env:CONDA_EXE   = $condaExe
        $Env:CONDA_ENV_EXE = Join-Path $root 'Scripts\conda-env.exe'

        # Import the module directly (NO -ArgumentList)
        Import-Module $psm1 -ErrorAction Stop

        # After module import, a 'conda' function should exist
        if (-not (Get-Command conda -ErrorAction SilentlyContinue))
        {
            throw "Conda function was not created by $psm1"
        }

        conda activate $Name
    } catch
    {
        Write-Warning "Conda init/activate failed: $($_.Exception.Message)"
    }
}

# Does the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs
{
    if ($args.Count -gt 0)
    {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    } else
    {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

function clear-recyclebin
{
    Clear-RecycleBin -force
}

# yazi shell wrapper https://yazi-rs.github.io/docs/quick-start
function y
{
    yazi
}

function cat
{
    bat
}

function reload
{
    . $profile
}

function touch($file)
{
    "" | Out-File $file -Encoding ASCII
}

function df
{
    get-volume
}

function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function pkill($name)
{
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name)
{
    Get-Process $name
}

if (Test-Path Alias:ls)
{
    Remove-Item -Path Alias:ls
}

function ls
{eza  --long -a --group-directories-first --icons --color=auto --header
}

function ll
{eza -l
}

function la
{eza -a
}

function lt
{eza --tree
}

function e
{exit
}

function :q
{exit
}

function c
{clear
}

function fzfn
{nvim $(fzf --preview "bat {}")
}

function reboot
{Restart-Computer
}

function n
{nvim
}

function nvim-remove
{Remove-Item -Path "$Env:USERPROFILE\AppData\Local\nvim-data" -Recurse -Force
}

function lg
{lazygit
}

function ccd
{chezmoi cd
}
function cedit
{chezmoi edit
}
function cdiff
{chezmoi diff
}
function cstatus
{chezmoi status
}
function capply
{chezmoi -v apply
}

function ks
{komorebic-no-console start --config "$Env:USERPROFILE\.config\komorebi\komorebi.json" --ahk
}

function ke
{komorebic stop --ahk
}

function su
{scoop update
}

function ss
{scoop status
}

function sua
{scoop update --all
}

function Get-UncPath
{
    param([string]$Path)

    $resolved = Convert-Path $Path
    $drive = $resolved.Substring(0,2)
    $unc   = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$drive'").ProviderName
    if ($unc)
    {
        return $resolved.Replace($drive, $unc)
    } else
    {
        return $resolved
    }
}

function wezterm-update-plugins
{
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        $Args
    )
    $script = "$env:USERPROFILE\.config\wezterm\wezterm-update-plugins.ps1"
    if (-not (Test-Path $script))
    { Write-Error "Script not found: $script"; return 
    }
    & $script @Args
}

# function ai { aider --model gpt-5 --chat-mode ask --no-git }
# function ai-openai { aider --model gpt-5-mini --chat-mode architect --watch-files }
# function ai-deepseek-r1 { aider --model ollama_chat/deepseek-r1:latest --chat-mode architect --watch-files}
# function ai-llama3.1 { aider --model ollama_chat/llama3.1:latest --chat-mode architect --watch-files}
# function ai-gptoss { aider --model ollama_chat/gpt-oss:latest --chat-mode architect --watch-files}

function ai
{
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Message)
    $text = $Message -join ' '
    opencode --model openai/gpt-5 run $text
}

function ai-gpt-5-mini
{ 
    opencode --model openai/gpt-5-mini
}

# function ai-pull-all { (Invoke-RestMethod http://localhost:11434/api/tags).Models.Name.ForEach{ ollama pull $_ } }

$Env:XDG_CONFIG_HOME = "$Env:USERPROFILE\.config"

$Env:MPV_HOME = "$Env:USERPROFILE\.config\mpv"

$Env:KOMOREBI_CONFIG_HOME = "$Env:USERPROFILE\.config\komorebi"
$Env:KOMOREBI_AHK_EXE = "$Env:USERPROFILE\scoop\apps\autohotkey\current\UX\AutoHotkeyUX.exe"

$Env:GDAL_DRIVER_PATH = "$Env:USERPROFILE\gdal-env\.pixi\envs\default\Library\lib\gdalplugins"

$Env:GLAZEWM_CONFIG_PATH = "$Env:USERPROFILE\.config\glazewm\config.yaml"

$Env:VISUAL = 'nvim'
$Env:EDITOR = 'nvim'
$Env:SHELL = 'pwsh'
$Env:COLORTERM = 'truecolor'

$Env:PYENV = "$Env:USERPROFILE\.pyenv\pyenv-win\"
$Env:PYENV_HOME = "$Env:USERPROFILE\.pyenv\pyenv-win\"
$Env:PYENV_ROOT = "$Env:USERPROFILE\.pyenv\pyenv-win\"

# Auto-activate venv if it exists
$venvPath = "$Env:USERPROFILE\.pyenv\pyenv-win\versions\3.12.10\env-geopeek\Scripts\Activate.ps1"
if (Test-Path $venvPath)
{
    & $venvPath
}

$Env:PIPX_DEFAULT_PYTHON = "$Env:USERPROFILE\pipx\shared\Scripts\python.exe"

$ENV:STARSHIP_CONFIG = "$Env:USERPROFILE\.config\starship\starship.toml"

$Env:BAT_CONFIG_DIR = "$Env:USERPROFILE\.config\bat\"
$Env:BAT_CONFIG_PATH = "$Env:USERPROFILE\.config\bat\bat.conf"

$ENV:YAZI_FILE_ONE = "$Env:USERPROFILE\scoop\apps\git\current\usr\bin\file.exe"
$Env:YAZI_CONFIG_HOME = "$Env:USERPROFILE\.config\yazi" 

$Env:NEOVIM_NODE_PATH = "$USERPROFILE\scoop\apps\nodejs-nightly\current\node.exe"

$Env:CUDA_PATH = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8" 
$Env:CUDA_PATH_V12_8 = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8" 

# Define fzf options

function f() {
    $file = fd | fzf
    if ($file) { Get-Item $file }
}

## FZF, PSFZF, and PSREADLINE tools

# Ensure modules are loaded
Import-Module PSReadLine
Import-Module PSFzf

# PSReadLine settings
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
# Set-PSReadLineOption -EditMode Vi
# Set-PSReadLineOption -ViModeIndicator Prompt
# Set-PSReadLineKeyHandler -Key Ctrl+h -ScriptBlock { Invoke-FzfHistory }
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

# Improve syntax highlighting
# Set-PSReadLineOption -Colors @{
#     "Command"        = "#B4DFFE"
#     "Parameter"      = "#F0A0FF"
#     "String"         = "#A8FF60"
#     "Operator"       = "#FFD500"
#     "Variable"       = "#FFB05E"
#     "Number"         = "#FF8C69"
# }

# PSFzf keybindings
# Match fzf defaults from Unix (Ctrl-T, Ctrl-R, Alt-C)

Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+t' `
    -HistorySearchProvider 'Ctrl+r' `
    -FileSystemNavigation 'Alt+c' `
    -MatchFuzzySetProvider 'Ctrl+f'

# --- FZF default settings for better UX ---
$env:FZF_DEFAULT_OPTS = @(
  "--preview 'bat --style=numbers --color=always {}'"
  "--preview-window=right:60%"
  "--height=60%"
  "--layout=reverse"
  "--border"
  "--info=inline"
  "--prompt='❯ '"

  # Catppuccin Macchiato Colors
  "--color=bg+:#1e2030,bg:#181926,spinner:#f4dbd6,hl:#ed8796"
  "--color=fg:#cad3f5,header:#f5bde6,info:#8bd5ca,pointer:#f4dbd6"
  "--color=marker:#ed8796,fg+:#cad3f5,prompt:#89b4fa,hl+:#f38ba8"

  # Preview settings
  "--preview 'pwsh -NoProfile -File $HOME/.config/fzf/fzf_preview.ps1 {}'"
  "--preview-window=right,60%,border-left"
) -join ' '



$Env:EZA_CONFIG_DIR = "$Env:USERPROFILE\.config\eza"

$Env:OLLAMA_HOST = "0.0.0.0:11434"
$Env:OLLAMA_API_BASE = "https://ollama.azinsharaf.net"
$Env:OLLAMA_BASE_URL = "https://ollama.azinsharaf.net"
$Env:OLLAMA_CONTEXT_LENGTH = 65000
$Env:OLLAMA_NUM_THREADS = 8

# shell_gpt config
$Env:CHAT_CACHE_PATH = "$Env:USERPROFILE\AppData\Local\Temp\chat_cache"
$Env:CACHE_PATH = "$Env:USERPROFILE\AppData\Local\Temp\cache"
$Env:CHAT_CACHE_LENGTH = "100"
$Env:CACHE_LENGTH = "100"
$Env:REQUEST_TIMEOUT = "60"
$Env:DEFAULT_MODEL = "gpt-4o"
$Env:DEFAULT_COLOR = "magenta"
$Env:ROLE_STORAGE_PATH = "$Env:USERPROFILE\.config\shell_gpt\roles"
$Env:DEFAULT_EXECUTE_SHELL_CMD = "false"
$Env:DISABLE_STREAMING = "false"
$Env:CODE_THEME = "one-dark"
$Env:OPENAI_FUNCTIONS_PATH = "$Env:USERPROFILE\.config\shell_gpt\functions"
$Env:OPENAI_USE_FUNCTIONS = "true"
$Env:SHOW_FUNCTIONS_OUTPUT = "false"
$Env:API_BASE_URL = "default"
$Env:PRETTIFY_MARKDOWN = "true"
$Env:USE_LITELLM = "false"
$Env:SHELL_INTERACTION = "true"
$Env:OS_NAME = "auto"
$Env:SHELL_NAME = "auto"

$Env:Path += ";C:\msys64\mingw64\bin"
$Env:Path += ";$Env:USERPROFILE\.cargo\bin"
$Env:Path += ";$Env:USERPROFILE\scoop\shims"
$Env:Path += ";$Env:USERPROFILE\.local\bin"
$Env:Path += ";$Env:USERPROFILE\.pyenv\pyenv-win\bin"
$Env:Path += ";$Env:USERPROFILE\.pyenv\pyenv-win\shims"
$Env:Path += ";$Env:USERPROFILE\gdal-env\.pixi\envs\default\Library\bin"
$Env:Path += ";$Env:USERPROFILE\pdal-env\.pixi\envs\default\Library\bin"
$Env:Path += ";C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8\bin"
$Env:Path += ";C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8\libnvvp"
$Env:Path += ";C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common"
$Env:Path += ";C:\Program Files\NVIDIA Corporation\Nsight Compute 2025.1.0"

# using starship prompt
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })



