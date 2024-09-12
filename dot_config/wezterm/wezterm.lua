local wezterm = require 'wezterm'

return {
    -- Appearance
    color_scheme = "tokyonight_night", -- Change to your preferred color scheme
    -- colors = {
    --     background = "#000000",
    -- },
    font = wezterm.font("JetBrainsMono Nerd Font"), -- Change to your preferred font
    font_size = 10.0,
    initial_cols = 300,
    initial_rows = 50,

    -- Transparency
    window_background_opacity = 1, -- Set transparency (0.0 to 1.0, where 1.0 is fully opaque)

    -- Keybindings (Vim-like motions)
    keys = {

        -- Add this line to open the Launcher with Ctrl + Shift + Space
        { key = "Space",      mods = "CTRL|SHIFT", action = wezterm.action.ShowLauncher },

        -- Navigate panes with Ctrl + Shift + H/J/K/L
        { key = "H",          mods = "CTRL|SHIFT", action = wezterm.action { ActivatePaneDirection = "Left" } },
        { key = "J",          mods = "CTRL|SHIFT", action = wezterm.action { ActivatePaneDirection = "Down" } },
        { key = "K",          mods = "CTRL|SHIFT", action = wezterm.action { ActivatePaneDirection = "Up" } },
        { key = "L",          mods = "CTRL|SHIFT", action = wezterm.action { ActivatePaneDirection = "Right" } },

        -- Split panes with Ctrl + Shift + S (horizontal) and Ctrl + Shift + V (vertical)
        { key = "S",          mods = "CTRL|SHIFT", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
        { key = "V",          mods = "CTRL|SHIFT", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },

        -- Resize panes with Ctrl + Shift + Arrow Keys
        { key = "LeftArrow",  mods = "CTRL|SHIFT", action = wezterm.action { AdjustPaneSize = { "Left", 1 } } },
        { key = "DownArrow",  mods = "CTRL|SHIFT", action = wezterm.action { AdjustPaneSize = { "Down", 1 } } },
        { key = "UpArrow",    mods = "CTRL|SHIFT", action = wezterm.action { AdjustPaneSize = { "Up", 1 } } },
        { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action { AdjustPaneSize = { "Right", 1 } } },

        -- Copy and paste with Ctrl + Shift + C/V
        { key = "C",          mods = "CTRL",       action = wezterm.action { CopyTo = "Clipboard" } },
        { key = "V",          mods = "CTRL",       action = wezterm.action { PasteFrom = "Clipboard" } },

        -- Open a new tab with Ctrl + Shift + T, close it with Ctrl + Shift + W
        { key = "T",          mods = "CTRL|SHIFT", action = wezterm.action { SpawnTab = "DefaultDomain" } },
        { key = "W",          mods = "CTRL|SHIFT", action = wezterm.action { CloseCurrentTab = { confirm = true } } },

        -- Quick switch between tabs with Ctrl + Shift + 1-9
        { key = "1",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 0 } },
        { key = "2",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 1 } },
        { key = "3",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 2 } },
        { key = "4",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 3 } },
        { key = "5",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 4 } },
        { key = "6",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 5 } },
        { key = "7",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 6 } },
        { key = "8",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 7 } },
        { key = "9",          mods = "CTRL|SHIFT", action = wezterm.action { ActivateTab = 8 } },

        -- Launch programs (Ctrl + Shift + P for PowerShell, Ctrl + Shift + E for Explorer)
        { key = "E",          mods = "CTRL|SHIFT", action = wezterm.action { SpawnCommandInNewTab = { args = { "explorer.exe" } } } },
    },

    -- Mouse Bindings
    mouse_bindings = {
        -- Right-click paste from clipboard
        {
            event = { Down = { streak = 1, button = "Right" } },
            mods = "NONE",
            action = wezterm.action { PasteFrom = "Clipboard" },
        },

        -- Ctrl + Left-click to open a hyperlink
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = wezterm.action.OpenLinkAtMouseCursor,
        },

        {
            event = { Drag = { streak = 1, button = 'Left' } },
            mods = 'SUPER',
            action = wezterm.action.StartWindowDrag,
        },
        {
            event = { Drag = { streak = 1, button = 'Left' } },
            mods = 'CTRL|SHIFT',
            action = wezterm.action.StartWindowDrag,
        },
    },

    -- Other important settings
    enable_scroll_bar = false,           -- Disable the scroll bar
    hide_tab_bar_if_only_one_tab = true, -- Hide tab bar if there's only one tab
    use_fancy_tab_bar = false,           -- Simple tab bar
    window_decorations = "RESIZE",       -- Only allow resizing

    -- Set default program for Windows (using PowerShell)
    default_prog = { "pwsh.exe", "-Nologo" },
}
