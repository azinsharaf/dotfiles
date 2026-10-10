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

TBD

## WSL Setup (WIP)

TBD

## WSL Arch Linux Setup

TBD
