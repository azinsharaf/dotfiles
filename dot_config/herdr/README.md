# Herdr Configuration

This directory contains the configuration for Herdr, a runtime environment for coding agents.

## Quick Start

- **Config file:** `config.toml`
- **Keybindings reference:** `KEYBINDINGS.md`
- **Scripts:** `scripts/` directory

## Keybindings Quick Reference

### Prefix Key
All keybindings use `Ctrl+A` as the prefix (leader key).

### Workspaces (Space Navigation)
| Key | Action |
|-----|--------|
| `Ctrl+A w` | Pick workspace (interactive) |
| `Ctrl+A [` | Previous workspace |
| `Ctrl+A ]` | Next workspace |

### Tabs (Tab Management)
| Key | Action |
|-----|--------|
| `Ctrl+A c` | New tab |
| `Ctrl+A q` | Close tab |
| `Ctrl+A h` | Previous tab |
| `Ctrl+A l` | Next tab |
| `Ctrl+Alt+h` | Previous tab (rapid, no prefix) |
| `Ctrl+Alt+l` | Next tab (rapid, no prefix) |
| `Ctrl+Tab` | Toggle last tab |

### Panes (Pane Management)
| Key | Action |
|-----|--------|
| `Ctrl+A Shift+N` | New pane |
| `Ctrl+A x` | Close pane |
| `Ctrl+A j` | Focus left pane |
| `Ctrl+A k` | Focus right pane |
| `Ctrl+A v` | Split pane vertically (right) |
| `Ctrl+A -` | Split pane horizontally (down) |
| `Ctrl+A m` | Enter resize mode |

### Agents (Agent Navigation)
| Key | Action |
|-----|--------|
| `Ctrl+A Tab` | Next agent |
| `Ctrl+A Shift+Tab` | Previous agent |

### Projects & UI (High Frequency)
| Key | Action |
|-----|--------|
| `Ctrl+A p` | Pick project (fzf popup) |
| `Ctrl+A e` | Toggle sidebar visibility |
| `Ctrl+A r` | Reload config |

## Configuration Overview

### Theme
- **Current:** Tokyo Night

### Terminal
- **Default shell:** Nu (nu.exe)
- **New pane cwd:** Follow parent directory

### UI
- **Sidebar:** Show agent labels on pane borders
- **Sorting:** Agents grouped by spaces
- **Toast delivery:** Herdr

## Custom Scripts

Located in `scripts/` directory:

| Script | Binding | Purpose |
|--------|---------|---------|
| `pick-project.nu` | `Ctrl+A p` | Interactive project/workspace picker using fzf |
| `toggle-sidebar.nu` | `Ctrl+A e` | Toggle sidebar visibility via Herdr API |
| `tab-toggle.nu` | `Ctrl+Tab` | Toggle between last focused tabs |
| `seed-tabs.nu` | Internal | Initialize tabs for new workspaces |

## Productivity Tips

### Fast Tab Cycling (Zellij-style)
For rapid tab navigation without re-pressing the prefix:
```
Ctrl+Alt+l, Ctrl+Alt+l, Ctrl+Alt+l
```

### Workspace Cycling
Navigate between spaces sequentially:
```
Ctrl+A [ (previous)
Ctrl+A ] (next)
```

### Pane Resizing
1. Press `Ctrl+A m` to enter resize mode
2. Use arrow keys to resize panes
3. Press `Escape` or re-press `Ctrl+A` to exit

### Creating a New Workspace
1. Press `Ctrl+A p` to open project picker
2. Select a project (or create new workspace)
3. Herdr will initialize it with default tabs

## File Structure

```
dot_config/herdr/
├── config.toml              # Main configuration file
├── README.md                # This file
├── KEYBINDINGS.md           # Detailed keybindings reference
└── scripts/
    ├── pick-project.nu      # Project picker script
    ├── toggle-sidebar.nu    # Sidebar toggle script
    ├── tab-toggle.nu        # Tab toggle script
    └── seed-tabs.nu         # Tab seeding script
```

## Editing Configuration

Edit `config.toml` directly, then reload with:
```
Ctrl+A r
```

Or from shell:
```bash
herdr server reload-config
```

## Useful Commands

```bash
# List all workspaces
herdr workspace list

# Focus a specific workspace
herdr workspace focus <workspace_id>

# Create new workspace
herdr workspace create --cwd <path> --label <name>

# Get API snapshot (current state)
herdr api snapshot

# Reload config
herdr server reload-config
```

## Troubleshooting

### Sidebar toggle not working
The `toggle-sidebar.nu` script uses Herdr's API. If it doesn't work:
- Check if Herdr supports UI state toggling
- Verify the API endpoints are available in your Herdr version

### Keybindings not responding
- Reload config with `Ctrl+A r`
- Check for conflicts with your terminal or system keybindings
- Verify key syntax in `config.toml`

### Custom scripts not executing
- Ensure scripts have correct permissions
- Verify Nu shell is installed and working
- Check script paths are correctly expanded with `~`

## See Also

- Detailed keybindings: `KEYBINDINGS.md`
- Herdr docs: https://herdr.dev/docs
- Herdr GitHub: https://github.com/herdrdev/herdr
