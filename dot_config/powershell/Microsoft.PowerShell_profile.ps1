

Set-PSReadlineOption -EditMode vi -viModeIndicator Cursor
# Enabling Menu Completion 
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

#arcgis pro python env activation

# $Env:CONDA_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda.exe"
# $Env:CONDA_ENV_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda-env.exe"
# $Env:_CE_M = ""
# $Env:_CE_CONDA = ""
# $Env:_CONDA_ROOT = "C:\Program Files\ArcGIS\Pro\bin\Python"
# $Env:_CONDA_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda.exe"
# $CondaModuleArgs = @{ChangePs1 = $True}
# Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs
#
# conda activate arcgispro-py3-clone

# cmu python env activation

$Env:CONDA_EXE = "C:\Users\azin\scoop\apps\anaconda3\current\App\Scripts\conda.exe"
$Env:CONDA_ENV_EXE = "C:\Users\azin\scoop\apps\anaconda3\current\App\Scripts\conda-env.exe"
$Env:_CE_M = ""
$Env:_CE_CONDA = ""
$Env:_CONDA_ROOT = "C:\Users\azin\scoop\apps\anaconda3\current\App"
$Env:_CONDA_EXE = "C:\Users\azin\scoop\apps\anaconda3\current\App\Scripts\conda.exe"
$CondaModuleArgs = @{ChangePs1 = $True}
Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs

conda activate cmu-python-1

Remove-Variable CondaModuleArgs

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    } else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

function reload-profile {
    & "$Env:USERPROFILE\Documents\PowerShell\profile.ps1"
}

function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

function df {
    get-volume
}

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    Get-Process $name
}

Remove-Item -Path Alias:ls

function ls {lsd -la}

function ll {lsd -l}
function la {lsd -a}
function lt {lsd --tree}
function e {exit}
function :q {exit}
function c {clear}

function fzfp {fzf --preview "cat {}"}
function fzfn {nvim $(fzf --preview "cat {}")}

function reboot {Restart-Computer}

function n {nvim}
function nvim-remove {Remove-Item -Path "$Env:USERPROFILE\AppData\Local\nvim-data" -Recurse -Force}

function lg {lazygit}

function cedit {chezmoi edit}
function cdiff {chezmoi diff}
function cstatus {chezmoi status}
function capply {chezmoi -v apply}
function ccd {chezmoi cd}

function ks {komorebic start --config "$Env:USERPROFILE\.config\komorebi\komorebi.json" --ahk --bar}

function ke {komorebic stop --bar}

$Env:XDG_CONFIG_HOME = "$Env:USERPROFILE\.config"

$Env:KOMOREBI_CONFIG_HOME = "$Env:USERPROFILE\.config\komorebi"
$Env:KOMOREBI_AHK_EXE = "$Env:USERPROFILE\AppData\Local\Programs\AutoHotkey\v2\AutoHotkey64.exe"
# $Env:WHKD_CONFIG_HOME = "$Env:USERPROFILE\.config\whkd"

$Env:VISUAL = 'nvim'
$Env:EDITOR = 'nvim'
$Env:SHELL = 'pwsh'

$Env:PYENV = "$Env:USERPROFILE\.pyenv\pyenv-win\"
$Env:PYENV_HOME = "$Env:USERPROFILE\.pyenv\pyenv-win\"
$Env:PYENV_ROOT = "$Env:USERPROFILE\.pyenv\pyenv-win\"

$ENV:STARSHIP_CONFIG = "$Env:USERPROFILE\.config\starship\starship.toml"

$ENV:YAZI_FILE_ONE = "$Env:USERPROFILE\scoop\apps\git\current\usr\bin\file.exe"

# if ($env:COMPUTERNAME -eq "Desktop-Azin") {
#     $env:NEOVIM_NODE_PATH = "C:\Program Files\nodejs\node.exe"
# } elseif ($env:COMPUTERNAME -eq "WS-Oakland-001") {
#     $env:NEOVIM_NODE_PATH = "C:\Users\asharaf\scoop\apps\nodejs\current\node.exe"
# }

$Env:Path = "$Env:USERPROFILE\scoop\apps\nodejs-lts\current;$Env:PATH"
$Env:Path += ";C:\msys64\mingw64\bin"
$Env:Path += ";$Env:USERPROFILE\.cargo\bin"
$Env:Path += ";$Env:USERPROFILE\scoop\apps\7zip\current"
$Env:Path += ";$Env:USERPROFILE\.pyenv\pyenv-win\versions\3.12.1\env-shellgpt\Scripts"
$Env:Path += ";$Env:USERPROFILE\scoop\apps\git\current\usr\bin"

# using starship prompt
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })



