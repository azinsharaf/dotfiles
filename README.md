# Personal Development Environment (PDE)

> Browser bookmarks (`AppData/Roaming/qutebrowser/config/bookmarks/urls`) and the `gh` hosts file are intentionally **not** tracked — they may contain internal-network, work, or personal URLs/tokens and are kept local-only.

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

The full list lives in the PowerShell script. To install everything on a new Windows machine:

```pwsh
pwsh ~/scripts/windows/install-scoop-apps.ps1
```

#### uv applications

```shell
cargo install --locked uv
uv tool install sqlit-tui # A user friendly TUI for SQL databases.
```

#### Python Virtual Environments

User-level Python venvs (in `~/.venvs/`) that the Obsidian "obsidian_terminal" plugin
and Neovim's Python provider depend on. The dotfiles repo ships bootstrap scripts in
`~/.config/uv/scripts/` — run them once after `chezmoi apply` on a new machine.

```pwsh
# Obsidian "obsidian_terminal" plugin (Python 3.11)
pwsh ~/.config/uv/scripts/install-obsidian-terminal.ps1

# Neovim's Python provider (Python 3.12)
pwsh ~/.config/uv/scripts/install-pynvim.ps1
```

After running, point the consuming tool at the rebuilt interpreter:

- **Obsidian** plugin settings → Python path:
  `C:\Users\<you>\.venvs\obsidian_terminal\Scripts\python.exe`
- **Neovim** is already configured to use
  `C:\Users\<you>\.venvs\pynvim\Scripts\python.exe`
  (see `dot_config/nvim/lua/config/globals.lua.tmpl`).

#### rust (cargo) applications

`cargo install --git https://github.com/8LWXpg/dwag` # drag drop in terminal (windows version)
`cargo install --git https://github.com/siriusmart/youtube-tui`
`cargo install --git https://github.com/nevermore23274/AetherTune` # radio in terminal
`cargo install --git https://github.com/christo-auer/eilmeldung` # RSS reader in temrinal
`cargo install --locked tabiew` # view and query tabular data files, such as CSV, Parquet, Arrow, and ... it has issue on windows

#### go applications

`go install github.com/Gaurav-Gosain/tuios/cmd/tuios@latest # tuios`

#### Additional Tools

```shell
pipx install rich-cli
pipx install shell-gpt
pipx install aider-chat
pipx install euporie
pipx install viewtif # https://github.com/nkeikon/tifviewer
pipx install csvkit
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

### Debian Installation

```powershell
wsl --install Debain
wsl --update
wsl -l # list of installed distro
wsl --set-default Debian
wsl.exe
```

```bash
sudo apt update && sudo apt upgrade -y
```

### setup `zsh`

```bash
sudo apt install zsh
chsh -s $(which zsh) # make zsh your default shell

```

### Linux Packages Installation

```zsh
sudo apt update && sudo apt upgrade -y
sudo apt install curl
sudo apt install build-essential -y
sudo apt install git -y
sudo apt install neovim
sudo apt install fortune-mod -y
sudo apt install ripgrep -y
sudo apt install neofetch -y # neofetch
sudo apt install bat -y
sudo apt install btop -y
sudo apt install mpv -y
sudo apt-get install ninja-build gettext cmake unzip curl -y
sudo apt install -y pkg-config libssl-dev

curl https://sh.rustup.rs -sSf | sh

# apps with rust
cargo install du-dust

cargo install youtube-tui --all-features


# Autosuggestions

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc


# Syntax highlighting

git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc


# Then reload Zsh:

source ~/.zshrc


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
