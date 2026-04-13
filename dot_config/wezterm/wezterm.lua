local wezterm = require("wezterm")
local act = wezterm.action

local config = {

	-- Import configurations from other files
	-- keys = require("keybindings"),
	disable_default_key_bindings = false,
	font = require("fonts"),
	color_scheme = require("colors"),
	-- Appearance settings
	-- hide_tab_bar_if_only_one_tab = false, -- Disabled: using Zellij tabs/status
	-- tab_bar_at_bottom = true, -- Disabled: using Zellij tabs/status
	-- use_fancy_tab_bar = true, -- Disabled: using Zellij tabs/status
	enable_tab_bar = false, -- Disable WezTerm tabs entirely (Zellij handles tabs)
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
	enable_scroll_bar = false,
	scrollback_lines = 5000,
	enable_kitty_keyboard = false,
	enable_csi_u_key_encoding = false,
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
	window_background_opacity = 0.90, -- WezTerm handles transparency (uniform across terminal content)
	text_background_opacity = 1.0, -- Text backgrounds opaque relative to window
	default_workspace = "default",
	-- status_update_interval = 1000, -- Disabled: using Zellij status
}

-- Pick default shell by OS
if wezterm.target_triple:find("windows") then
	config.default_prog = {
		"pwsh.exe",
		"-NoLogo",
	}
else
	config.default_prog = { "/bin/zsh", "-l" }
end

config.keys = {

	-- Send Ctrl+Tab as kitty-encoded CSI sequence to Zellij
	-- CSI 9;5u = Tab(9) with Ctrl modifier(5) in kitty keyboard protocol
	{
		key = "Tab",
		mods = "CTRL",
		action = act.SendString("\x1b[9;5u"),
	},

	-- Activate the previously active tab
	{
		key = "o",
		mods = "CTRL|SHIFT",
		action = act.ShowTabNavigator,
	},

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

return config
