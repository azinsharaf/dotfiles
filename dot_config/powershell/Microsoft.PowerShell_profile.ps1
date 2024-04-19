

Set-PSReadlineOption -EditMode vi -viModeIndicator Cursor

#arcgis pro python env activation

$Env:CONDA_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda.exe"
$Env:CONDA_ENV_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda-env.exe"
$Env:_CE_M = ""
$Env:_CE_CONDA = ""
$Env:_CONDA_ROOT = "C:\Program Files\ArcGIS\Pro\bin\Python"
$Env:_CONDA_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda.exe"
$CondaModuleArgs = @{ChangePs1 = $True}
Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs

conda activate arcgispro-py3-clone

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

function btop {btop4win}

function ls {lsd}
function l {lsd -l}
function la {lsd -a}
function lla {lsd -la}
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

function ks {komorebic start --config "$Env:USERPROFILE\.config\komorebi\komorebi.json" --whkd}

function ke {komorebic stop --whkd}

function sql {C:\Users\asharaf\scoop\apps\go-sqlcmd\current\sqlcmd.exe}

$Env:XDG_CONFIG_HOME = "$Env:USERPROFILE\.config"

$Env:KOMOREBI_CONFIG_HOME = "$Env:USERPROFILE\.config\komorebi"
$Env:WHKD_CONFIG_HOME = "$Env:USERPROFILE\.config\whkd"

$Env:SHELL = 'pwsh'
$Env:VISUAL = 'nvim'
$Env:EDITOR = 'nvim'
# $Env:HOME = $Env:USERPROFILE

$Env:PYENV = "$Env:USERPROFILE\.pyenv\pyenv-win\"
$Env:PYENV_HOME = "$Env:USERPROFILE\.pyenv\pyenv-win\"
$Env:PYENV_ROOT = "$Env:USERPROFILE\.pyenv\pyenv-win\"

$ENV:STARSHIP_CONFIG = "$Env:USERPROFILE\.config\starship\starship.toml"

if ($env:COMPUTERNAME -eq "Desktop-Azin") {
    $env:NEOVIM_NODE_PATH = "C:\Program Files\nodejs\node.exe"
} elseif ($env:COMPUTERNAME -eq "WS-Oakland-001") {
    $env:NEOVIM_NODE_PATH = "C:\Users\asharaf\scoop\apps\nodejs\current\node.exe"
}


$Env:Path += ";C:\msys64\mingw64\bin"
$Env:Path += ";C:\msys64\mingw64\bin"
$Env:Path += ";C:\Users\asharaf\scoop\apps\nodejs\current"
$Env:Path += ";C:\Users\asharaf\.cargo\bin"

# using starship prompt
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })



