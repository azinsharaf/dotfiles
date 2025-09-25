local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local function detect_os()
	local target = wezterm.target_triple
	if target:find("windows") then
		return "windows"
	elseif target:find("darwin") then
		return "macos"
	end
end

local computer_name = os.getenv("COMPUTERNAME") or os.getenv("HOSTNAME")

local config = {
	-- Import configurations from other files
	keys = require("keybindings"),
	font = require("fonts"),
	color_scheme = require("colors"),
	-- Appearance settings
	hide_tab_bar_if_only_one_tab = true, -- Hide the tab bar if there's only one tab
	tab_bar_at_bottom = true, -- Move the tab bar to the bottom
	use_fancy_tab_bar = true, -- Enable fancy tab bar
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", -- Remove the title bar
	window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	},
	initial_rows = 30,
	initial_cols = 100,
	enable_scroll_bar = true, -- Enable scroll bar
	scrollback_lines = 5000,
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
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
	default_workspace = "~",
	status_update_interval = 1000,
}
if detect_os() == "windows" then
	config.default_prog = { "pwsh" }
elseif detect_os() == "macos" then
	config.default_prog = { "/bin/zsh" }
end

-- switch to workspace
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

config.keys = {
	-- Switch to the default workspace
	{
		key = "y",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "default",
		}),
	},
	-- Switch to a monitoring workspace, which will have `top` launched into it
	{
		key = "b",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "monitoring",
			spawn = {
				args = { "btop" },
			},
		}),
	},
	{
		key = "n",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "neovim",
			spawn = {
				args = { "nvim" },
			},
		}),
	},
	-- Create a new workspace with a random name and switch to it
	{ key = "i", mods = "CTRL|SHIFT", action = act.SwitchToWorkspace },
	-- Show the launcher in fuzzy selection mode and have it list all workspaces
	-- and allow activating one.
	{
		key = "9",
		mods = "CTRL",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES|TABS",
		}),
	},
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ShowLauncher },
}

-- gui startup
-- wezterm.on("gui-startup", function(cmd)
-- 	local tab, pane, window = mux.spawn_window(cmd or {})
-- 	-- Create a split occupying the right 1/3 of the screen
-- 	pane:split({ size = 0.3 })
-- 	-- Create another split in the right of the remaining 2/3
-- 	-- of the space; the resultant split is in the middle
-- 	-- 1/3 of the display and has the focus.
-- 	pane:split({ size = 0.5 })
-- end)
--

-- mux startup

-- this is called by the mux server when it starts up.
-- It makes a window split top/bottom
wezterm.on("mux-startup", function()
	local tab, pane, window = mux.spawn_window({})
	pane:split({ direction = "Top" })
end)

return config
