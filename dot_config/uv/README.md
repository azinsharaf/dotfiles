# `~/.config/uv/` — Python venv bootstrap scripts

This directory is managed by [chezmoi](https://www.chezmoi.io/) and ships
PowerShell scripts that rebuild the user-level Python venvs under
`~/.venvs/` on a new machine.

## Scripts

| Script                                  | Rebuilds                     | Python | Used by                             |
| --------------------------------------- | ---------------------------- | ------ | ----------------------------------- |
| `scripts/install-obsidian-terminal.ps1` | `~/.venvs/obsidian_terminal` | 3.11   | Obsidian "obsidian_terminal" plugin |
| `scripts/install-pynvim.ps1`            | `~/.venvs/pynvim`            | 3.12   | Neovim Python provider              |

All scripts are **idempotent** — safe to re-run.

## Quick start

After `chezmoi apply` on a new machine:

```pwsh
pwsh ~/.config/uv/scripts/install-obsidian-terminal.ps1
pwsh ~/.config/uv/scripts/install-pynvim.ps1
```

Each script prints the path to the rebuilt `python.exe` at the end —
point the consuming tool (Obsidian plugin / Neovim) at that path.

## More info

See the main chezmoi README for full setup details and the broader Python
environment strategy (project-local `.venv/` for projects, `~/.venvs/` for
user tools, `ca` for ArcGIS conda):

[github.com/azinsharaf/dotfiles — Python Virtual Environments](../../../../../README.md#python-virtual-environments)
