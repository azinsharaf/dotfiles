# Herdr Keybindings Reference

## Quick Cheat Sheet

### WORKSPACES (Space Navigation)
```
Ctrl+A w       → Pick workspace (interactive picker)
Ctrl+A [       → Previous workspace
Ctrl+A ]       → Next workspace
```

### TABS (Tab Management)
```
Ctrl+A c       → New tab (create)
Ctrl+A q       → Close tab (quit)
Ctrl+A h       → Previous tab
Ctrl+A l       → Next tab
Ctrl+Alt+h     → Previous tab (rapid fire, no prefix needed)
Ctrl+Alt+l     → Next tab (rapid fire, no prefix needed)
Ctrl+Tab       → Toggle last tab (quick switch)
```

### PANES (Pane Management)
```
Ctrl+A Shift+N → New pane (create)
Ctrl+A x       → Close pane (exit)
Ctrl+A j       → Focus left pane
Ctrl+A k       → Focus right pane
Ctrl+A v       → Split pane vertically (right)
Ctrl+A -       → Split pane horizontally (down)
Ctrl+A m       → Enter resize mode (use arrows to resize)
```

### AGENTS (Agent Navigation)
```
Ctrl+A Tab           → Next agent
Ctrl+A Shift+Tab     → Previous agent
```

### PROJECTS & UI (High Frequency Actions)
```
Ctrl+A p       → Pick project (high frequency - fzf picker)
Ctrl+A e       → Toggle sidebar visibility
Ctrl+A r       → Reload config
```

## Productivity Tips

### Fast Tab Cycling (Replaces Zellij behavior)
- **Normal way:** `Ctrl+A l`, `Ctrl+A l`, `Ctrl+A l` (press prefix each time)
- **Rapid way:** `Ctrl+Alt+l`, `Ctrl+Alt+l`, `Ctrl+Alt+l` (hold down without prefix)
  
Use the rapid way when you need quick tab navigation!

### Workspace Navigation
- Use `Ctrl+A [` and `Ctrl+A ]` to quickly cycle through your spaces
- Or use `Ctrl+A w` for an interactive picker if you have many spaces

### Pane Resizing
1. Press `Ctrl+A m` to enter resize mode
2. Use arrow keys to resize panes
3. Press `Escape` or `Ctrl+A` to exit

## Configuration File Location
`~/.config/herdr/config.toml`

## Custom Scripts Location
`~/.config/herdr/scripts/`

Scripts in use:
- `pick-project.nu` - Project picker (bound to Ctrl+A p)
- `toggle-sidebar.nu` - Sidebar toggle (bound to Ctrl+A e)
- `tab-toggle.nu` - Tab switcher (bound to Ctrl+Tab)
- `seed-tabs.nu` - Tab initialization (used by project picker)
