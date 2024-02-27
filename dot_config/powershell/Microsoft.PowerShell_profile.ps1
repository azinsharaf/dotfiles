# using starship prompt
Invoke-Expression (&starship init powershell)

Set-PSReadlineOption -EditMode vi -viModeIndicator Cursor

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

function ls {lsd}
function l {lsd -l}
function la {lsd -a}
function lla {lsd -la}
function lt {lsd --tree}
function e {exit}
function :q {exit}
function c {clear}
function fzfp {fzf --preview 'cat {}'}
function fzfn {nvim $(fzf --preview 'cat {}')}
function reboot {Restart-Computer}

function ca {chezmoi -v apply}
function ccd {chezmoi cd}
function cdiff {chezmoi diff}


function ks {
	& "C:\Program Files\komorebi\bin\komorebic.exe" start --config "$Env:USERPROFILE\.config\komorebi\komorebi.json" --whkd
}

function ke {komorebic stop}


$Env:XDG_CONFIG_HOME = "$Env:USERPROFILE\.config"

$Env:KOMOREBI_CONFIG_HOME = '$Env:USERPROFILE\.config\komorebi'
$Env:WHKD_CONFIG_HOME = '$Env:USERPROFILE\.config\whkd'
# $Env:WHKD_CONFIG_HOME = 'C:\Users\asharaf\.config\whkd'

$Env:SHELL = 'pwsh'
$Env:VISUAL = 'nvim'
$Env:EDITOR = 'nvim'

$Env:PYENV = '$Env:USERPROFILE\.pyenv\pyenv-win\'
$Env:PYENV_HOME = '$Env:USERPROFILE\.pyenv\pyenv-win\'
$Env:PYENV_ROOT = '$Env:USERPROFILE\.pyenv\pyenv-win\'


$env:Path += ";C:\msys64\mingw64\bin"
