# Herdr Configuration

This directory contains the configuration for Herdr, a runtime environment for coding agents.

## Quick Start

- **Config file:** `config.toml`
- **Scripts:** `scripts/` directory

## Keybindings Quick Reference

### Prefix Key

All keybindings use `Ctrl+A` as the prefix (leader key).

### Workspaces (Space Navigation)

| Key        | Action                       |
| ---------- | ---------------------------- |
| `Ctrl+A w` | Pick project / workspace (fzf popup) |

### Tabs (Tab Management)

| Key          | Action                          |
| ------------ | ------------------------------- |
| `Ctrl+A c`       | New tab                         |
| `Ctrl+A Shift+X` | Close tab                       |
| `Ctrl+A p`       | Previous tab                    |
| `Ctrl+A n`       | Next tab                        |
| `Ctrl+Tab`       | Toggle last tab                 |

### Panes (Pane Management)

| Key              | Action                         |
| ---------------- | ------------------------------ |
| `Ctrl+A h`        | Focus pane left                |
| `Ctrl+A j`        | Focus pane down                |
| `Ctrl+A k`        | Focus pane up                  |
| `Ctrl+A l`        | Focus pane right               |
| `Ctrl+A Tab`      | Cycle to next pane             |
| `Ctrl+A Shift+Tab`| Cycle to previous pane         |
| `Ctrl+A x`        | Close pane                     |
| `Ctrl+A v`        | Split pane vertically (right)  |
| `Ctrl+A -`        | Split pane horizontally (down) |
| `Ctrl+A r`        | Enter resize mode              |

### Agents (Agent Navigation)

`Ctrl+A Tab` / `Ctrl+A Shift+Tab` cycle panes (herdr defaults). Use the sidebar to focus agents.

### Projects & UI (High Frequency)

| Key        | Action                    |
| ---------- | ------------------------- |
| `Ctrl+A w`       | Pick project (fzf popup)      |
| `Ctrl+A Shift+R` | Reload config (herdr default) |

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

| Script              | Binding    | Purpose                                        |
| ------------------- | ---------- | ---------------------------------------------- |
| `pick-project.nu`   | `Ctrl+A w` | Interactive project/workspace picker using fzf |
| `tab-toggle.nu`     | `Ctrl+Tab` | Toggle between last focused tabs               |
| `seed-tabs.nu`      | Internal   | Initialize tabs for new workspaces             |

## Productivity Tips

### Workspace Navigation

Open the project/workspace picker:

```
Ctrl+A w
```

### Pane Resizing

1. Press `Ctrl+A r` to enter resize mode
2. Use arrow keys to resize panes
3. Press `Escape` or re-press `Ctrl+A` to exit

### Creating a New Workspace

1. Press `Ctrl+A w` to open project picker
2. Select a project (or create new workspace)
3. Herdr will initialize it with default tabs

## File Structure

```
dot_config/herdr/
├── config.toml              # Main configuration file
├── README.md                # This file
└── scripts/
    ├── pick-project.nu      # Project picker script
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
