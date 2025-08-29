# Personal Development Environments (PDE)

## Windows Setup

### Install Applications

#### MS Store Apps

- Install iCloud app from MS Store version 15.x

#### Winget Apps

```shell
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
```

#### Manual Installations

- MS Teams
- Workspot Client
- ArcGIS Pro

### Install Scoop

```shell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex

scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts
scoop bucket add nonportable
```

#### Scoop Apps

```shell
scoop install nonportable/files-np
# Enable catppuccin theme in Files
. { Invoke-WebRequest -UseBasicParsing https://github.com/catppuccin/windows-files/raw/main/install.ps1 } | iex

scoop install git-with-openssh
scoop install make
scoop install gcc
scoop install nerd-fonts/JetBrainsMono-NF
scoop install nerd-fonts/FiraCode-NF
scoop install nerd-fonts/Hack-NF
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
scoop install spotify-player
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
scoop install zebar
scoop install uutils-coreutils
scoop install speedtest-cli
scoop install dust
scoop install pandoc
scoop install flow-launcher
scoop install mpv
scoop install yt-dlp
scoop install bitwarden
scoop install bitwarden-cli
```

#### Additional Tools

```shell
pipx install rich-cli
pipx install shell-gpt
pipx install aider-chat

npm install -g neovim
npm install -g pnpm@latest-10
```

#### Other Installations

- Install Win11 Toggle Rounded Corner: [GitHub Link](https://github.com/oberrich/win11-toggle-rounded-corners)

```shell
scoop bucket add CrypticButter https://github.com/CrypticButter/ScoopBucket
scoop install CrypticButter/buttery-taskbar
scoop install pandoc
```

## MacOS Setup

### Install Homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Homebrew Cask Apps

```shell
brew install --cask font-jetbrains-mono-nerd-font
brew install wezterm@nightly
brew install whatsapp
brew install --cask zen-browser
brew install --cask nikitabobko/tap/aerospace
```

### Homebrew CLI Tools

```shell
brew install lazygit
brew install starship
brew install chezmoi
brew install yazi --HEAD
brew install btop
brew install spotify
brew install lsd
brew install anaconda
brew install karabiner-elements
brew install betterdisplay
brew install oscar
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
brew install wget
brew install luarocks
brew install pipx
```

### Additional Tools

```shell
pipx install yewtube
npm install -g neovim
```

### Python Setup

```shell
brew install pyenv
brew install pyenv-virtualenv

pyenv install 3.11.11
pyenv virtualenv 3.11.11 env-shellgpt
~/.pyenv/versions/3.11.11/envs/env-shellgpt/bin/python -m pip install --upgrade pip

# Jupyter Lab
pip install catppuccin-jupyterlab
```

## WSL Setup (WIP)

### WSL Installation

```powershell
wsl --install Debain
wsl --update
```

### Linux Packages Installation

```zsh
sudo apt update && sudo apt upgrade -y
sudo apt install curl
sudo apt install build-essential -y

# Install Rust and Cargo
curl https://sh.rustup.rs -sSf | sh -s -- -y
cargo install macchina
sudo apt install zsh -y
sudo apt install git -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # oh-my-zsh
curl -sS https://starship.rs/install.sh | sh # starship prompt
sudo apt install neofetch -y # neofetch

# Additional Tools
sudo apt install exa -y
sudo apt install ripgrep -y
sudo apt install fortune-mod -y
sudo apt install bat -y
cargo install du-dust
cargo install --locked zellij

sudo apt install btop -y
sudo apt install lf -y
sudo apt install mpv -y
sudo apt-get install ninja-build gettext cmake unzip curl -y

# Alacritty Terminal
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
sudo apt install alacritty -y

# Pyenv Pre-requisites
sudo apt update && sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

curl https://pyenv.run | bash # pyenv

pyenv install 3.11.5
pyenv virtualenv 3.11.5 env-wsl-apps
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install --upgrade pip

# Python Apps for WSL
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install pyqt6

# Qutebrowser
sudo apt install qt6-tools-dev
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install qutebrowser
```

## WSL Arch Linux Setup

### Enable WSL and Virtual Machine Features

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

### Download and Install WSL Kernel Update

```powershell
Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -Outfile $Env:USERPROFILE\Downloads\wsl_update_x64.msi
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$Env:USERPROFILE\Downloads\wsl_update_x64.msi`" /qn" -Verb RunAs
Restart-Computer
```

### Install Arch Linux

```powershell
mkdir C:\WSL\Arch
Invoke-WebRequest -Uri https://github.com/yuk7/ArchWSL/releases/download/22.10.16.0/Arch.zip -OutFile C:\WSL\Arch\Arch.zip
Expand-Archive -LiteralPath "C:\WSL\Arch\Arch.zip" -DestinationPath "C:\WSL\Arch"
C:\WSL\Arch\Arch.exe # to install Arch
C:\WSL\Arch\Arch.exe # run it again to setup root password
```

### Setup Default User

```shell
[root@PC-NAME] passwd
[root@PC-NAME] echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
[root@PC-NAME] useradd -m -G wheel -s /bin/bash {username}
[root@PC-NAME] passwd {username}
[root@PC-NAME] exit
C:\WSL\Arch\Arch.exe config --default-user {username}
```

### Set Default WSL Distribution

```powershell
wsl.exe -l -v
wsl --set-default Arch
wsl.exe --update
wsl.exe --shutdown
```

### Arch Linux Setup

```shell
# Initialize Keyring
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman -Sy archlinux-keyring
sudo pacman -Su

# Install Yay
sudo pacman -S base-devel
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

# Install Tools
yay -S neofetch
yay -S zsh
chsh -s /bin/bash azin

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sS https://starship.rs/install.sh | sh # starship prompt

# Additional Tools
sudo apt install exa -y
sudo apt install ripgrep -y
sudo apt install fortune-mod -y
sudo apt install bat -y
cargo install du-dust
cargo install --locked zellij

sudo apt install btop -y
sudo apt install lf -y
sudo apt install mpv -y
sudo apt-get install ninja-build gettext cmake unzip curl -y

# Alacritty Terminal
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
sudo apt install alacritty -y

# Pyenv Pre-requisites
sudo apt update && sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

curl https://pyenv.run | bash # pyenv

pyenv install 3.11.5
pyenv virtualenv 3.11.5 env-wsl-apps
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install --upgrade pip

# Python Apps for WSL
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install pyqt6

# Qutebrowser
sudo apt install qt6-tools-dev
~/.pyenv/versions/3.11.5/envs/env-wsl-apps/bin/python -m pip install qutebrowser
```
