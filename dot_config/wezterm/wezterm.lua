local wezterm = require("wezterm")
local mux = wezterm.mux

local function detect_os()
	local target = wezterm.target_triple
	if target:find("windows") then
		return "windows"
	elseif target:find("darwin") then
		return "macos"
	end
end

if detect_os() == "macos" then
	config.default_prog = { "/bin/zsh" }
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
	window_background_opacity = 0.9,
	text_background_opacity = 0.9,
	default_workspace = "~",
	status_update_interval = 1000,
}
if detect_os() == "windows" then
	config.default_prog = { "pwsh" }
end

local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)

wezterm.on("modal.enter", function(name, window, pane)
	modal.set_right_status(window, name)
	modal.set_window_title(pane, name)
end)

wezterm.on("modal.exit", function(name, window, pane)
	local title = basename(window:active_workspace())
	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = title .. "  " },
	}))
	modal.reset_window_title(pane)
end)

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.state_manager.periodic_save({
	interval_seconds = 15 * 60,
	save_workspaces = true,
	save_windows = true,
	save_tabs = true,
})

resurrect.state_manager.set_encryption({
	enable = false,
	private_key = wezterm.home_dir .. "/.age/resurrect.txt",
	public_key = "age1ddyj7qftw3z5ty84gyns25m0yc92e2amm3xur3udwh2262pa5afqe3elg7",
})

wezterm.on("resurrect.error", function(err)
	wezterm.log_error("ERROR!")
	wezterm.gui.gui_windows()[1]:toast_notification("resurrect", err, nil, 3000)
end)

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.apply_to_config({})

workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = colors.colors.ansi[3] } },
		{ Background = { Color = colors.colors.background } },
		{ Text = "󱂬 : " .. label },
	})
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,

		resize_window = false,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
	wezterm.log_info(window)
	window:gui_window():set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = colors.colors.ansi[5] } },
		{ Text = basename(path) .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	wezterm.log_info(window)
	local workspace_state = resurrect.workspace_state
	resurrect.state_manager.save_state(workspace_state.get_workspace_state())
	resurrect.state_manager.write_current_state(label, "workspace")
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.start", function(window, _)
	wezterm.log_info(window)
end)
wezterm.on("smart_workspace_switcher.workspace_switcher.canceled", function(window, _)
	wezterm.log_info(window)
end)

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "ALT",
	},
})
return config
