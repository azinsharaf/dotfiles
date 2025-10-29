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
	tab_bar_at_bottom = true, -- Move the tab bar to the bottom
	use_fancy_tab_bar = true, -- Enable fancy tab bar
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", -- Remove the title bar
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

local workspace_picker = wezterm.plugin.require("https://github.com/bugii/workspace-picker-plugin")

local home = os.getenv("HOME") or os.getenv("USERPROFILE") or ""

local function expand(p)
	if p:sub(1, 2) == "~/" then
		return home .. p:sub(2)
	end
	return p
end

local function deepcopy(t)
	if type(t) ~= "table" then
		return t
	end
	local u = {}
	for k, v in pairs(t) do
		u[k] = deepcopy(v)
	end
	return u
end

-- Put your list of repo/folder paths here (can be full paths or "~/"-prefixed)
local repos = {
	"~/repos/geopeek",
	"~/repos/alameda_gis_azure_maintenance",
	"~/repos/belmont_dmp_gis_maintenance",
	"~/repos/danville_dmp_gis_maintenance",
	"~/repos/dmp_inspection_report_generator",
	"~/repos/glendale_dmp_gis_maintenance",
	"~/repos/jn3614008_knights_landing",
	"~/repos/la_county_dmp_gis_maintenance",
	"~/repos/port_of_oakland_gis_maintenance",
	"~/repos/Processing_NOAA_AORC_NEXRAD",
	"~/repos/sde_creation",
	"~/repos/sdmp_condassess_rehabplan_script",
	"~/repos/wr_gis_icm",
	"~/repos/wri_gis_oakland_misc_tools",
	"~/repos/wri_gis_pythontoolbox",
	"~/repos/wri_gis_sdmppostprocessing",
	"~/repos/wri_gis_watersheds",
	"~/repos/wri_gis_weightedaverage",
	"~/repos/wri_sdmp_gis_tools",
	"~/.local/share/chezmoi",
}

-- Shared tab/pane template
local tabs_template = {
	{
		name = "editor",
		direction = "Right",
		panes = {
			{
				name = "nvim",
				command = "ca && nvim",
				direction = "Right",
				size = 2,
			},
			{
				name = "run",
				command = "ca && clear",
				direction = "Right",
				size = 1,
			},
		},
	},
	{ name = "ai", command = "opencode" },
	{ name = "git", command = "lazygit" },
	{ name = "yazi", command = "yazi" },
	{
		name = "notes",
		command = "cd '~/OneDrive - Wood Rodgers Inc/5 - azin_obsidian_work/' && nvim",
	},
	{ name = "btop", command = " btop" },
}

-- Build workspaces from repos list
local workspaces = {}
for _, raw in ipairs(repos) do
	local path = expand(raw)
	local tabs = deepcopy(tabs_template)

	-- Prefix `cd` to commands so panes/tabs start in the correct folder,
	-- but skip if the command already contains a `cd`.
	for _, tab in ipairs(tabs) do
		if tab.panes then
			for _, pane in ipairs(tab.panes) do
				if pane.command and not pane.command:match("^%s*cd%s+") then
					pane.command = string.format("cd %q && %s", path, pane.command)
				end
			end
		else
			if tab.command and not tab.command:match("^%s*cd%s+") then
				tab.command = string.format("cd %q && %s", path, tab.command)
			end
		end
	end

	table.insert(workspaces, {
		path = path,
		type = "directory",
		tabs = tabs,
	})
end

workspace_picker.setup(workspaces, {
	icons = {
		directory = "📁",
		worktree = "🌳",
		zoxide = "⚡",
		workspace = "🖥️",
	},
})

-- Apply to config with custom keybinding
workspace_picker.apply_to_config(config, "f", "CTRL")

-- tab bar plugin
-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config)

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Catppuccin Mocha",
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
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = { " " },
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = { "ram", "cpu" },
		tabline_y = { "datetime", "battery" },
		tabline_z = { "domain" },
	},
	extensions = {},
})

tabline.apply_to_config(config)

return config
