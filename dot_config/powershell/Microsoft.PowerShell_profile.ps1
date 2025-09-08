Set-PSReadlineOption -EditMode vi -viModeIndicator Cursor
# Enabling Menu Completion 
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Conda (ArcGIS Pro) activator: ca [envname]
function ca {
  param([string]$Name = 'arcgispro-py3-clone')

  $root = 'C:\Program Files\ArcGIS\Pro\bin\Python'
  $condaExe = Join-Path $root 'Scripts\conda.exe'
  $psm1     = Join-Path $root 'shell\condabin\Conda.psm1'

  if (-not (Test-Path -LiteralPath $psm1)) {
    Write-Warning "Conda.psm1 not found at: $psm1"
    return
  }
  if (-not (Test-Path -LiteralPath $condaExe)) {
    Write-Warning "conda.exe not found at: $condaExe"
    return
  }

  try {
    # prevent conda from altering the prompt
    $Env:CONDA_CHANGEPS1 = "false"

    $Env:_CONDA_ROOT = $root
    $Env:_CONDA_EXE  = $condaExe
    $Env:CONDA_EXE   = $condaExe
    $Env:CONDA_ENV_EXE = Join-Path $root 'Scripts\conda-env.exe'

    # Import the module directly (NO -ArgumentList)
    Import-Module $psm1 -ErrorAction Stop

    # After module import, a 'conda' function should exist
    if (-not (Get-Command conda -ErrorAction SilentlyContinue)) {
      throw "Conda function was not created by $psm1"
    }

    conda activate $Name
  }
  catch {
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
function y {
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
{komorebic start --config "$Env:USERPROFILE\.config\komorebi\komorebi.json" --ahk
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

function ai { aider --no-git --model ollama_chat/llama3.1:8b --chat-mode ask}

function ai-deepseek { aider --model ollama_chat/deepseek-r1:8b --chat-mode architect ask}
function ai-gemma { aider --model ollama_chat/gemma3:12b --chat-mode ask }
function ai-qwen { aider --model ollama_chat/qwen2.5-coder:3b --chat-mode architect ask }
function ai-llama { aider --model ollama_chat/llama3.1:8b --chat-mode ask }

function ai-openai { aider --model gpt-4o --chat-mode ask }

function ai-codegemma { aider --model ollama_chat/codegemma:7b --chat-mode architect --watch-files }
function ai-codeqwen2.5 { aider --model ollama_chat/qwen2.5-coder:7b --chat-mode architect --watch-files }

function ai-pull-all { (Invoke-RestMethod http://localhost:11434/api/tags).Models.Name.ForEach{ ollama pull $_ } }

$Env:XDG_CONFIG_HOME = "$Env:USERPROFILE\.config"

$Env:MPV_HOME = "$Env:USERPROFILE\.config\mpv"

$Env:KOMOREBI_CONFIG_HOME = "$Env:USERPROFILE\.config\komorebi"
$Env:KOMOREBI_AHK_EXE = "$Env:USERPROFILE\AppData\Local\Programs\AutoHotkey\v2\AutoHotkey64.exe"

$Env:GDAL_DRIVER_PATH = "$Env:USERPROFILE\gdal-env\.pixi\envs\default\Library\lib\gdalplugins"

$Env:GLAZEWM_CONFIG_PATH = "$Env:USERPROFILE\.config\glazewm\config.yaml"

$Env:VISUAL = 'nvim'
$Env:EDITOR = 'nvim'
$Env:SHELL = 'pwsh'
$Env:COLORTERM = 'truecolor'

$Env:PYENV = "$Env:USERPROFILE\.pyenv\pyenv-win\"
$Env:PYENV_HOME = "$Env:USERPROFILE\.pyenv\pyenv-win\"
$Env:PYENV_ROOT = "$Env:USERPROFILE\.pyenv\pyenv-win\"

$ENV:STARSHIP_CONFIG = "$Env:USERPROFILE\.config\starship\starship.toml"

$Env:BAT_CONFIG_DIR = "$Env:USERPROFILE\.config\bat\"
$Env:BAT_CONFIG_PATH = "$Env:USERPROFILE\.config\bat\bat.conf"

$ENV:YAZI_FILE_ONE = "$Env:USERPROFILE\scoop\apps\git\current\usr\bin\file.exe"
$Env:YAZI_CONFIG_HOME = "$Env:USERPROFILE\.config\yazi" 

$Env:NEOVIM_NODE_PATH = "$USERPROFILE\scoop\apps\nodejs-nightly\current\node.exe"

$Env:CUDA_PATH = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8" 
$Env:CUDA_PATH_V12_8 = "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.8" 

# Define fzf options

$Env:FZF_DEFAULT_OPTS = '--height=70% --layout=reverse --border ' +
                        '--preview "if (Test-Path {}) { bat --style=numbers --color=always --line-range=:500 {} } else { Get-Item {} | Format-List * }" ' +
                        '--preview-window=right:70% ' +
                        '--bind "j:down,k:up,h:toggle-preview,l:accept"'

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



