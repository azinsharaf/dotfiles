# Personal Development Environment (PDE)

## Windows Setup


### Winget Apps

```shell
winget install CLechasseur.PathCopyCopy # Windows Explorer extension for copying file paths
winget install Logitech.OptionsPlus # Logitech device configuration
winget install Nvidia.GeForceExperience # NVIDIA GPU management
```

### Install Scoop Package Manager

```shell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex

scoop bucket add main
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts
scoop bucket add nonportable
```

### Install apps via Scoop

The full list lives in the PowerShell script. To install everything on a new Windows machine:

```pwsh
pwsh ~/scripts/windows/install-scoop-apps.ps1
```

### uv applications

Install `uv` per OS (Scoop on Windows, `pacman`/`brew` on Linux/mac, or see https://docs.astral.sh/uv/getting-started/installation/):

```shell
# Linux (Arch):  sudo pacman -S uv
# macOS:         brew install uv
# Windows:       scoop install main/uv  (included in install script above)

uv tool install sqlit-tui # A user friendly TUI for SQL databases.
```

### Python Virtual Environments

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

### rust (cargo) applications

`cargo install --git https://github.com/8LWXpg/dwag` # drag drop in terminal (windows version)
`cargo install --git https://github.com/siriusmart/youtube-tui`
`cargo install --git https://github.com/nevermore23274/AetherTune` # radio in terminal
`cargo install --git https://github.com/christo-auer/eilmeldung` # RSS reader in temrinal
`cargo install --locked tabiew` # view and query tabular data files, such as CSV, Parquet, Arrow, and ... it has issue on windows

### Additional Tools

```shell
pipx install rich-cli
pipx install shell-gpt
pipx install aider-chat
pipx install euporie
pipx install viewtif # https://github.com/nkeikon/tifviewer
pipx install csvkit
```

### Other Installations

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

## Linux Setup

TBD

## MacOS Setup

TBD
