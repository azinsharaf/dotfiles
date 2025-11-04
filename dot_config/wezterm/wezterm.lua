local wezterm = require("wezterm")
local act = wezterm.action

local config = {

    default_prog = { "pwsh.exe", "-NoLogo" },
    -- Import configurations from other files
    -- keys = require("keybindings"),
    disable_default_key_bindings = false,
    font = require("fonts"),
    color_scheme = require("colors"),
    -- Appearance settings
    hide_tab_bar_if_only_one_tab = false, -- Hide the tab bar if there's only one tab
    tab_bar_at_bottom = true,             -- Move the tab bar to the bottom
    use_fancy_tab_bar = true,             -- Enable fancy tab bar
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",        -- Remove the title bar
    window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
    },
    initial_rows = 30,
    initial_cols = 100,
    enable_scroll_bar = true, -- Enable scroll bar
    scrollback_lines = 5000,
    front_end = "WebGpu",
    -- webgpu_preferred_adapter = (function()
    -- 	if computer_name == "Azin-Desktop" then
    -- 		return {
    -- 			backend = "Vulkan",
    -- 			device_type = "DiscreteGpu",
    -- 			name = "NVIDIA GeForce RTX 4070 SUPER",
    -- 		}
    -- 	elseif computer_name == "Machine2" then
    -- 		return {
    -- 			backend = "Vulkan",
    -- 			device_type = "DiscreteGpu",
    -- 			name = "Another GPU Name",
    -- 		}
    -- 	else
    -- 		return {
    -- 			backend = "Vulkan",
    -- 			device_type = "DiscreteGpu",
    -- 			name = "Default GPU Name",
    -- 		}
    -- 	end
    -- end)(),
    max_fps = 240,
    window_background_opacity = 0.8,
    text_background_opacity = 0.8,
    default_workspace = "default",
    status_update_interval = 1000,
}

config.keys = {

    -- Move focus between panes with Ctrl+Shift + H/J/K/L (use uppercase to override builtins)
    {
        key = "H",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "J",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = "K",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "L",
        mods = "CTRL|SHIFT",
        action = act.ActivatePaneDirection("Right"),
    },

    -- Resize panes with Ctrl+Alt+Shift + H/J/K/L (use uppercase to override builtins)
    {
        key = "H",
        mods = "CTRL|ALT|SHIFT",
        action = act.AdjustPaneSize({ "Left", 1 }),
    },
    {
        key = "J",
        mods = "CTRL|ALT|SHIFT",
        action = act.AdjustPaneSize({ "Down", 1 }),
    },
    {
        key = "K",
        mods = "CTRL|ALT|SHIFT",
        action = act.AdjustPaneSize({ "Up", 1 }),
    },
    {
        key = "L",
        mods = "CTRL|ALT|SHIFT",
        action = act.AdjustPaneSize({ "Right", 1 }),
    },
}

local workspace_picker = require("workspace_picker")
workspace_picker.apply(config)

local tabline_plugin = require("tabline")
tabline_plugin.apply(config)

local rename_tabs = require("rename_tabs")

table.insert(config.keys, rename_tabs.get_keybinding())

return config
