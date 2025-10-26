# Personal Development Environment (PDE)

## Windows Setup

### Install Applications

#### MS Store Apps

- Install iCloud app from MS Store version 15.x

#### Winget Apps

```shell
winget install Adobe.Acrobat.Reader.64-bit # PDF reader
winget install CLechasseur.PathCopyCopy # Windows Explorer extension for copying file paths
winget install Devolutions.RemoteDesktopManager # Remote connection management
winget install Doist.Todoist # Task management and to-do list
winget install KeeperSecurity.KeeperDesktop # Password manager
winget install Logitech.OptionsPlus # Logitech device configuration
winget install Microsoft.Office # Office suite
winget install Microsoft.SQLServer.2022.Developer # SQL Server 2022 Developer Edition
winget install Microsoft.SQLServerManagementStudio # SQL Server Management Studio
winget install Nvidia.GeForceExperience # NVIDIA GPU management
winget install lgug2z.komorebi # Tiling Windows Manager
```

#### Manual Installations

- MS Teams
- Workspot Client
- ArcGIS Pro
- Ducker Desktop

### Install Scoop

```shell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex

scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts
scoop bucket add nonportable
scoop bucket add CrypticButter https://github.com/CrypticButter/ScoopBucket
```

#### Scoop Apps

```shell
scoop install anaconda3 # Data science platform
scoop install autohotkey # Scripting language for Windows automation
scoop install bat # A cat clone with syntax highlighting
scoop install bitwarden # Password manager
scoop install bitwarden-cli # Command-line interface for Bitwarden
scoop install brave-nightly # Privacy-focused web browser
scoop install broot # A new way to see and navigate directory trees
scoop install btop-lhm # Resource monitor
scoop install chafa # Terminal graphics for the 21st century
scoop install chezmoi # Manage your dotfiles across multiple machines
scoop install clipboard # Clipboard manager
scoop install CrypticButter/buttery-taskbar # Taskbar customization tool
scoop install discord # Voice and text chat for gamers
scoop install dust # More intuitive version of du in rust
scoop install eza # Modern replacement for ls
scoop install extras/qmk-toolbox # QMK Firmware flashing tool
scoop install extras/via # VIA configurator for keyboards
scoop install fd # Simple, fast, and user-friendly alternative to find
scoop install ffmpeg # Multimedia framework
scoop install flow-launcher # Productivity tool to quickly search and launch
scoop install fzf # Command-line fuzzy finder
scoop install gh # GitHub’s official command line tool
scoop install git-with-openssh # Git version control with OpenSSH
scoop install glow # Render markdown on the CLI
scoop install greenshot # Screenshot tool
scoop install hexyl # A command-line hex viewer
scoop install imagemagick # Image processing tools
scoop install jq # Command-line JSON processor
scoop install keepass # Password manager
scoop install keyviz # Keypress visualizer
scoop install lazygit # Simple terminal UI for git commands
scoop install lf # Terminal file manager
scoop install lsd # The next gen ls command
scoop install luarocks # Package manager for Lua modules
scoop install make # Utility for directing compilation
scoop install main/7zip # File archiver with a high compression ratio
scoop install motrix # Full-featured download manager
scoop install nerd-fonts/FiraCode-NF # FiraCode Nerd Font
scoop install nerd-fonts/Hack-NF # Hack Nerd Font
scoop install nerd-fonts/JetBrainsMono-NF # JetBrainsMono Nerd Font
scoop install neovim-nightly # Hyperextensible Vim-based text editor
scoop install nodejs-lts # JavaScript runtime built on Chrome's V8
scoop install nonportable/files-np # File manager
scoop install notepadplusplus # Text editor
scoop install obsidian # Knowledge base that works on top of a local folder of plain text Markdown files
scoop install pandoc # Universal document converter
scoop install pipx # Install and run Python applications in isolated environments
scoop install poppler # PDF rendering library
scoop install pwsh # PowerShell Core
scoop install qutebrowser # A keyboard-driven, vim-like browser
scoop install extras/zen-browser # Zen Browser
scoop install revouninstaller # Uninstall software and remove unwanted programs
scoop install ripgrep # Line-oriented search tool
scoop install scoop install speedtest-cli # Internet speed testing from the command line
scoop install spotify # Music streaming service
scoop install spotify-player # Command-line Spotify client
scoop install starship # The minimal, blazing-fast, and infinitely customizable prompt for any shell
scoop install steam # Digital distribution platform for video games
scoop install thunderbird # Email client
scoop install treesize-free # Disk space analyzer
scoop install tree-sitter # Incremental parsing system for programming tools
scoop install uutils-coreutils # Cross-platform Rust rewrite of the GNU coreutils
scoop install wezterm-nghtly # GPU-accelerated terminal emulator
scoop install yazi # Blazing fast terminal file manager
scoop install yt-dlp # A youtube-dl fork with additional features
scoop install zebar # Barcode reader
scoop install zoom # Video conferencing tool
scoop install zoxide # A smarter cd command
scoop install main/pixi # python package management tool
scoop install dua # disk usage analyzer
scoop install exiftool # get the metadata of pictures
scoop install mediainfo # get the metadata of videos
scoop install less
scoop install extras/opencode # ai coding agent
```

#### Additional Tools

```shell
pipx install rich-cli
pipx install shell-gpt
pipx install aider-chat
pipx install euporie
pipx install viewtif # https://github.com/nkeikon/tifviewer
```

#### Other Installations

- Install Win11 Toggle Rounded Corner: [GitHub Link](https://github.com/oberrich/win11-toggle-rounded-corners)
- GDAL:

```pwsh
pixi init gdal-env
cd gdal-env
pixi add gdal libgdal-core
```

- PDAL:

  ```pwsh
  pixi init pdal-env
  cd pdal-env
  pixi add pdal
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
