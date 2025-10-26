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

local workspace_switcher = wezterm.plugin.require("https://github.com/bugii/workspace-picker-plugin")

-- Configure workspaces
workspace_switcher.setup({
    {
        path = "~/repos/geopeek/",
        type = "directory",
        tabs = {
            {
                name = "tab-1",
                direction = "Right",
                panes = {
                    {
                        name = "pane-1",
                        command = "cd ~/repos/geopeek/ && ca && nvim",
                        direction = "Right",
                        size = 2,
                    },
                    {
                        name = "pane-2",
                        command = "cd ~/repos/geopeek/ && ca && clear",
                        direction = "Right",
                        size = 1,
                    },
                },
            },
            { name = "ai",   command = "cd ~/repos/geopeek/ && opencode" },
            { name = "yazi", command = "cd ~/repos/geopeek/ && yazi" },
            { name = "btop", command = "cd ~/repos/geopeek/ && btop" },
        },
    },

    {
        path = "~/repos",
        type = "directory",
        tabs = {
            {
                name = "tab-1",
                direction = "Right",
                panes = {
                    {
                        name = "pane-1",
                        command = "nvim",
                        direction = "Right",
                        size = 2,
                    },
                    {
                        name = "pane-2",
                        command = "cd ~/repos && ca && clear",
                        direction = "Right",
                        size = 1,
                    },
                },
            },
            { name = "ai",    command = "ai-openai" },
            { name = "notes", command = "nvim" },
            { name = "yazi",  command = "yazi" },
            { name = "btop",  command = "btop" },
        },
    },

    {
        path = "~/.local/share/chezmoi",
        type = "directory",
        tabs = {
            {
                name = "tab-1",
                direction = "Right",
                panes = {
                    {
                        name = "pane-1",
                        command = "nvim",
                        direction = "Right",
                    },
                },
            },
            { name = "ai",    command = "ai-openai" },
            { name = "notes", command = "nvim" },
            { name = "yazi",  command = "yazi" },
            { name = "btop",  command = "btop" },
        },
    },

    {
        path = "~/OneDrive - Wood Rodgers Inc/5 - azin_obsidian_work",
        type = "directory",
        tabs = {
            {
                name = "tab-1",
                direction = "Right",
                panes = {
                    {
                        name = "pane-1",
                        command = "cd '~/OneDrive - Wood Rodgers Inc/5 - azin_obsidian_work' && nvim",
                        direction = "Right",
                        size = 1,
                    },
                },
            },
            { name = "yazi", command = "cd '~/OneDrive - Wood Rodgers Inc/5 - azin_obsidian_work' && yazi" },
        },
    },

    {
        path = "~/repos/wri_sdmp_gis_tools/",
        type = "directory",
        tabs = {
            {
                name = "tab-1",
                direction = "Right",
                panes = {
                    {
                        name = "pane-1",
                        command = "cd ~/repos/wri_sdmp_gis_tools/ && ca && nvim",
                        direction = "Right",
                        size = 2,
                    },
                    {
                        name = "pane-2",
                        command = "ca && clear",
                        direction = "Right",
                        size = 1,
                    },
                },
            },
            { name = "ai",   command = "cd ~/repos/wri_sdmp_gis_tools/ && opencode" },
            { name = "yazi", command = "cd ~/repos/wri_sdmp_gis_tools/ && yazi" },
            { name = "btop", command = "cd ~/repos/wri_sdmp_gis_tools/ && btop" },
        },
    },
}, {
    icons = {
        directory = "📁",
        worktree = "🌳",
        zoxide = "⚡",
        workspace = "🖥️",
    },
})

-- Apply to config with custom keybinding
workspace_switcher.apply_to_config(config, "f", "CTRL")

-- tab bar plugin
-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config)

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
    options = {
        icons_enabled = true,
        theme = 'Catppuccin Mocha',
        tabs_enabled = true,
        theme_overrides = {},
        section_separators = {
            left = wezterm.nerdfonts.pl_left_hard_divider,
            right = wezterm.nerdfonts.pl_right_hard_divider,
        },
        component_separators = {
            left = wezterm.nerdfonts.pl_left_soft_divider,
            right = wezterm.nerdfonts.pl_right_soft_divider,
        },
        tab_separators = {
            left = wezterm.nerdfonts.pl_left_hard_divider,
            right = wezterm.nerdfonts.pl_right_hard_divider,
        },
    },
    sections = {
        tabline_a = { 'mode' },
        tabline_b = { 'workspace' },
        tabline_c = { ' ' },
        tab_active = {
            'index',
            { 'parent', padding = 0 },
            '/',
            { 'cwd',    padding = { left = 0, right = 1 } },
            { 'zoomed', padding = 0 },
        },
        tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
        tabline_x = { 'ram', 'cpu' },
        tabline_y = { 'datetime', 'battery' },
        tabline_z = { 'domain' },
    },
    extensions = {},
})

tabline.apply_to_config(config)

return config
