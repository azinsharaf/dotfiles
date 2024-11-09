
# windows

## extra notes
```powershell

# setting powershell to work with arcgis pro conda env:
# first step - run in shell
# Define the folders to add to the PATH environment variable
$foldersToAdd = @("C:\Program Files\ArcGIS\Pro\bin\Python\Scripts", "C:\Users\asharaf\AppData\Local\ESRI\conda\envs\arcgispro-py3-clone\Scripts")

# Get the current user PATH environment variable
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")

# Initialize an empty string for the new folders
$newFolders = ""

# Iterate over each folder
foreach ($folderToAdd in $foldersToAdd) {
    # Check if the folder is already in the PATH
    if ($currentPath -notlike "*$folderToAdd*") {
        # If not, add the folder to the new folders string
        $newFolders += $folderToAdd + ";"
    } else {
        Write-Host "$folderToAdd is already in the PATH."
    }
}

# Add the new folders to the top of the PATH
$newPath = $newFolders + $currentPath
[Environment]::SetEnvironmentVariable("PATH", $newPath, "User")

# second step:
cd "C:\Program Files\ArcGIS\Pro\bin\Python\condabin"; .\conda init powershell

# third step:
Add-Content -Path "C:\Users\asharaf\Documents\PowerShell\profile.ps1" -Value @'
Invoke-Expression (&starship init powershell)
conda activate arcgispro-py3-clone
'@

# conda init powershell slows shell startup immensely, so run the following command in PowerShell:

# (& "C:\Program Files\/pyenvArcGIS\Pro\bin\Python\Scripts\conda.exe" "shell.powershell" "hook") | Out-String
# and copy the standard output into `profile.ps1` file and comment out the previous command in `profile.ps1`. The file should look like this after the change (remove the # signs)

# $Env:CONDA_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda.exe"
# $Env:CONDA_ENV_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda-env.exe"
# $Env:_CE_M = ""
# $Env:_CE_CONDA = ""
# $Env:_CONDA_ROOT = "C:\Program Files\ArcGIS\Pro\bin\Python"
# $Env:_CONDA_EXE = "C:\Program Files\ArcGIS\Pro\bin\Python\Scripts\conda.exe"
# $CondaModuleArgs = @{ChangePs1 = $True}
# Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1" -ArgumentList $CondaModuleArgs

# conda activate arcgispro-py3-clone

# Remove-Variable CondaModuleArgs
# Invoke-Expression (&starship init powershell

```



## windows, apps installation


```
# ms store apps
#install icloud app from ms store version 15.x

#winget apps
winget install KeeperSecurity.KeeperDesktop
winget install CLechasseur.PathCopyCopy
winget install Doist.Todoist
winget install Microsoft.Office 
winget install Logitech.OptionsPlus
winget install Microsoft.SQLServerManagementStudio
winget install  Microsoft.SQLServer.2022.Developer
winget install Devolutions.RemoteDesktopManager
winget install Adobe.Acrobat.Reader.64-bit
winget install Zen-Team.Zen-Browser
winget install Nvidia.GeForceExperience
winget install lgug2z.komorebi.nightly

# install manually
MS Teams
Workspot Client
ArcGIS Pro

# Install Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex

scoop install git-with-openssh
scoop install make
scoop install gcc
scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop install main/7zip
scoop install obsidian
scoop install notepadplusplus
scoop install pwsh
scoop install brave-nightly
scoop install keepass
scoop install nodejs-lts
scoop install qutebrowser
scoop install discord
scoop install ripgrep
scoop install fd
scoop install starship
scoop install lf
scoop install autohotkey
scoop install chezmoi
scoop install broot
scoop install lazygit
scoop install lsd
scoop install fzf
scoop install wezterm-nghtly
scoop install greenshot
scoop install keyviz
scoop install thunderbird
scoop install zoxide
scoop install bat
scoop install btop-lhm
scoop install jq
scoop install revouninstaller
scoop install spotify
scoop install extras/via
scoop install extras/qmk-toolbox
scoop install anaconda3
scoop install zoom
scoop install yazi
scoop install poppler
scoop install imagemagick
scoop install neovim-nightly
scoop install steam
scoop install clipboard
scoop install glow
scoop install pipx

scoop bucket add nerd-fonts
scoop install nerd-fonts/JetBrainsMono-NF

scoop install treesize-free

scoop install motrix

```


## wsl setup

wsl installation:
```powershell admin access
wsl --install Debain
wsl --update
```

linux packages installation

```zsh
sudo apt update && sudo apt upgrade -y

sudp apt install curl
sudo apt install build-essential -y

# install rust and cargo
curl https://sh.rustup.rs -sSf | sh
sudo apt install wmctrl -y
cargo install macchina
sudo apt install zsh -y
sudo apt install git -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # oh-my-zsh
curl -sS https://starship.rs/install.sh | sh # starship prompt
sudo apt install neofetch -y # neofetch

# sudo apt install x11-apps
sudo apt install exa -y
sudo apt install ripgrep -y
sudo apt install fortune-mod -y
sudo apt install bat -y
# sudo apt install cargo -y
cargo install du-dust
cargo install --locked zellij

sudo apt install btop -y
sudo apt install lf -y

sudo apt install mpv -y

sudo apt-get install ninja-build gettext cmake unzip curl -y


# alacritty terminal
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
sudo apt install alacritty -y



# pyenv pre-requisites
sudo apt update && sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

curl https://pyenv.run | bash # pyenv


pyenv install 3.11.5
pyenv virtualenv 3.11.5 env-wsl-apps
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install --upgrade pip

# python apps for wsl
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install pyqt6

# qutebrowser
sudo apt install qt6-tools-dev


~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install qutebrowser


```


## WSL Arch Linux setup

```powershell

# Enable the Windows Subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# download wsl kernel update
Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -Outfile $Env:USERPROFILE\Downloads\wsl_update_x64.msi

# install it silently
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$Env:USERPROFILE\Downloads\wsl_update_x64.msi`" /qn" -Verb RunAs

# reboot 
Restart-Computer

mkdir C:\WSL\Arch

Invoke-WebRequest -Uri https://github.com/yuk7/ArchWSL/releases/download/22.10.16.0/Arch.zip -OutFile C:\WSL\Arch\Arch.zip

Expand-Archive -LiteralPath "C:\WSL\Arch\Arch.zip" -DestinationPath "C:\WSL\Arch"

C:\WSL\Arch\Arch.exe # to install Arch

C:\WSL\Arch\Arch.exe # run it again to setup root password

[root@PC-NAME] passwd

# setup the default user
[root@PC-NAME] echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
#(setup sudoers file.)

# (add user) change {username} 
[root@PC-NAME] useradd -m -G wheel -s /bin/bash {username}

# (set default user password)
[root@PC-NAME] passwd {username}

[root@PC-NAME] exit

# (setting to default user)
C:\WSL\Arch\Arch.exe config --default-user {username}

wsl.exe -l -v
  NAME    STATE           VERSION
* Arch    Running         2

wsl --set-default Arch
The operation completed successfully.

wsl # ro run wsl

# run in powershell
wsl.exe --update
wsl.exe --shutdown

```


```shell
# in linux terminal
# initialize keyring

sudo pacman-key --init
sudo pacman-key --populate
sudo pacman -Sy archlinux-keyring
sudo pacman -Su

# install yay
sudo pacman -S base-devel
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git

cd yay && makepkg -si
sudo pacman -S base-devel

yay -S neofetch















# zsh
yay -S zsh
chsh -s /bin/bash azin

# ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"






curl -sS https://starship.rs/install.sh | sh # starship prompt

# sudo apt install x11-apps
sudo apt install exa -y
sudo apt install ripgrep -y
sudo apt install fortune-mod -y
sudo apt install bat -y
# sudo apt install cargo -y
cargo install du-dust
cargo install --locked zellij

sudo apt install btop -y
sudo apt install lf -y

sudo apt install mpv -y

sudo apt-get install ninja-build gettext cmake unzip curl -y


# alacritty terminal
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
sudo apt install alacritty -y





# pyenv pre-requisites
sudo apt update && sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

curl https://pyenv.run | bash # pyenv


pyenv install 3.11.5
pyenv virtualenv 3.11.5 env-wsl-apps
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install --upgrade pip

# python apps for wsl
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install pyqt6

# qutebrowser
sudo apt install qt6-tools-dev


~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install qutebrowser
```



some wls notes ot investigate:

running arcpy script from wsl:
❯ /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "& 'C:\Program Files\ArcGIS\Pro\bin\Python\envs\arcgispro-py3\python.exe' 'C:\Users\asharaf\repos\wr_gis_icm\icm_calc_pipe_deficiency.py'"

this works too: py on wsl location
~ via 🐍 v3.11.5
❯ /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "& 'C:\Program Files\ArcGIS\Pro\bin\Python\envs\arcgispro-py3\python.exe'" ./icm_calc_pipe_deficiency.py

~ via 🐍 v3.11.5 took 16s
❯ /mnt/c/Program\ Files/ArcGIS/Pro/bin/Python/envs/arcgispro-py3/python.exe icm_calc_pipe_deficiency.py
Start Time: 02/02/2024 10:06:05 AM



# macos

`
```shell

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/azin/.zprofile
 
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install --cask font-jetbrains-mono-nerd-font

brew install wezterm@nightly
brew install lazygit
brew install starship
brew install chezmoi
brew install yazi
brew install whatsapp
brew install btop
brew install spotify
brew install lsd
brew install anaconda
brew install karabiner-elements
brew install betterdisplay
brew install oscar
brew tap zen-browser/browser https://github.com/zen-browser/desktop.git
brew install --cask zen-browser
brew install zoxide
brew install glow
brew install ffmpegthumbnailer
brew install 7-zip
brew install jq
brew install poppler
brew install fd
brew install ripgrep
brew install fzf
brew install imagemagick
brew install ghostscript
``
```

`
