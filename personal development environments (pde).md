# Windows Setup

install the applications below:

```
# ms store apps
# install icloud app from ms store version 15.x

# winget apps
winget install KeeperSecurity.KeeperDesktop
winget install CLechasseur.PathCopyCopy
winget install Doist.Todoist
winget install Microsoft.Office
winget install Logitech.OptionsPlus
winget install Microsoft.SQLServerManagementStudio
winget install Microsoft.SQLServer.2022.Developer
winget install Devolutions.RemoteDesktopManager
winget install Adobe.Acrobat.Reader.64-bit
winget install Zen-Team.Zen-Browser
winget install Nvidia.GeForceExperience
winget install lgug2z.komorebi

# install these apps manually
MS Teams
Workspot Client
ArcGIS Pro

# Install Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex

scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts

scoop install git-with-openssh
scoop install make
scoop install gcc
scoop install nerd-fonts/JetBrainsMono-NF
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
scoop install hexyl
scoop install ffmpeg
scoop install chafa
scoop install eza
scoop install treesize-free
scoop install luarocks
scoop install motrix
scoop install pipx
scoop install tree-sitter
scoop install bc # basic calculator
scoop install gh

pipx install rich-cli
pipx install shell-gpt

npm install -g neovim


# install win11 toggle rounded corner
# https://github.com/oberrich/win11-toggle-rounded-corners

```

# MacOS setup

```shell

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
 
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install --cask font-jetbrains-mono-nerd-font
brew install wezterm@nightly
brew install lazygit
brew install starship
brew install chezmoi
brew install yazi --HEAD
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
brew install ffmpeg
brew install ffmpegthumbnailer
brew install 7-zip
brew install jq
brew install poppler
brew install fd
brew install ripgrep
brew install fzf
brew install imagemagick
brew install ghostscript
brew install hexyl
brew install rich-cli
brew install neofetch
brew install --cask nikitabobko/tap/aerospace
brew install wget
brew install luarocks
npm install -g neovim




brew install pyenv
brew install pyenv-virtualenv

pyenv install 3.11.11
pyenv virtualenv 3.11.11 env-shellgpt
~/.pyenv/versions/3.11.11/envs/env-shellgpt/bin/python -m pip install --upgrade pip

```

# WSL setup (WIP)

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
curl https://sh.rustup.rs -sSf | s
oscoop install pipx
trl -y
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

# WSL Arch Linux setup

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
