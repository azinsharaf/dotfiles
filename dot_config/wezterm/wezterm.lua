local wezterm = require("wezterm")

-- Initialize the configuration table
local config = wezterm.config_builder()

-- Set default program based on platform
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { "pwsh.exe", "-NoLogo" }
else
    config.default_prog = { "/bin/zsh" }
end

-- Appearance settings
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 10.0
config.command_palette_font_size = 10
config.window_frame = {
    font = wezterm.font("IBM Plex Sans"),
}
config.initial_cols = 200
config.initial_rows = 50
config.window_background_opacity = 0.9 -- Fully opaque
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.window_decorations = "RESIZE"

-- Keybindings (Vim-like motions)
config.keys = {
    -- Command Palette launcher
    { key = "Space",      mods = "CTRL|SHIFT", action = wezterm.action.ShowLauncher },
    { key = "X",          mods = "CTRL|SHIFT", action = wezterm.action.ActivateCopyMode },

    -- Pane navigation
    { key = "H",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
    { key = "J",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
    { key = "K",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
    { key = "L",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

    -- Pane splitting
    { key = "S",          mods = "CTRL|SHIFT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "V",          mods = "CTRL|SHIFT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

    -- Pane resizing
    { key = "LeftArrow",  mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }) },
    { key = "DownArrow",  mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }) },
    { key = "UpArrow",    mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
    { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }) },

    -- Copy and paste
    { key = "C",          mods = "CTRL",       action = wezterm.action({ CopyTo = "Clipboard" }) },
    { key = "V",          mods = "CTRL",       action = wezterm.action({ PasteFrom = "Clipboard" }) },

    -- Tab management
    { key = "T",          mods = "CTRL|SHIFT", action = wezterm.action({ SpawnTab = "DefaultDomain" }) },
    { key = "W",          mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },

    -- Quick tab switching
    { key = "1",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 0 }) },
    { key = "2",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 1 }) },
    { key = "3",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 2 }) },
    { key = "4",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 3 }) },
    { key = "5",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 4 }) },
    { key = "6",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 5 }) },
    { key = "7",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 6 }) },
    { key = "8",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 7 }) },
    { key = "9",          mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 8 }) },

    -- Launch external programs
    { key = "E",          mods = "CTRL|SHIFT", action = wezterm.action({ SpawnCommandInNewTab = { args = { "explorer.exe" } } }) },
}

-- Mouse bindings
config.mouse_bindings = {
    -- Right-click to paste
    { event = { Down = { streak = 1, button = "Right" } }, mods = "NONE",       action = wezterm.action({ PasteFrom = "Clipboard" }) },

    -- Ctrl + Left-click to open link
    { event = { Up = { streak = 1, button = "Left" } },    mods = "CTRL",       action = wezterm.action.OpenLinkAtMouseCursor },

    -- Window drag with Super or Ctrl + Shift + Left-click
    { event = { Drag = { streak = 1, button = "Left" } },  mods = "SUPER",      action = wezterm.action.StartWindowDrag },
    { event = { Drag = { streak = 1, button = "Left" } },  mods = "CTRL|SHIFT", action = wezterm.action.StartWindowDrag },
}

-- Other settings
config.enable_scroll_bar = false
config.default_prog = config.default_prog

return config
