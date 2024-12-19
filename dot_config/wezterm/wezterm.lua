local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

-- Initialize the configuration table
local config = wezterm.config_builder()

-- workspace switcher plugin
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
-- workspace_switcher.apply_to_config(config)

-- Set default program based on platform
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
else
	config.default_prog = { "/bin/zsh" }
end

-- Appearance settings
config.color_scheme = "Catppuccin Mocha"

config.unix_domains = { { name = "unix" } }

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12.0
config.line_height = 1.0
config.adjust_window_size_when_changing_font_size = false
config.command_palette_font_size = 14
config.window_frame = {
	font = wezterm.font("JetBrainsMono Nerd Font"),
}
config.initial_cols = 200
config.initial_rows = 50
config.window_background_opacity = 0.95
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32
config.switch_to_last_active_tab_when_closing_tab = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
config.integrated_title_button_style = "Windows"
config.integrated_title_button_alignment = "Right"
config.integrated_title_button_color = "Auto"

config.colors = {
	tab_bar = {
		active_tab = {
			-- I use a solarized dark theme; this gives a teal background to the active tab
			fg_color = "#073642",
			bg_color = "#2aa198",
		},
	},
}
config.default_workspace = "main"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.8,
}

-- config.disable_default_key_bindings = true

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {

	-- Command Palette launcher
	{ key = "Space", mods = "LEADER", action = wezterm.action.ShowLauncher },
	{ key = "x", mods = "LEADER", action = wezterm.action.ActivateCopyMode },

	-- Pane navigation
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

	-- Pane splitting
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
	},

	-- Pane resizing
	{ key = "LeftArrow", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "DownArrow", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "UpArrow", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "RightArrow", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },

	{
		key = "f",
		mods = "ALT",
		action = wezterm.action.TogglePaneZoomState,
	},
	-- Copy and paste
	{ key = "c", mods = "CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },

	-- Tab management
	{ key = "t", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "w", mods = "LEADER", action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },
	{ key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },

	-- Quick tab switching

	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },

	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Show list of workspaces
	{
		key = "s",
		mods = "LEADER",
		-- action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
		action = workspace_switcher.switch_workspace(),
	},
	-- Launch external programs
	{
		key = "e",
		mods = "LEADER",
		action = wezterm.action({ SpawnCommandInNewTab = { args = { "explorer.exe" } } }),
	},
}

-- Mouse bindings
config.mouse_bindings = {
	-- Right-click to paste
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action({ PasteFrom = "Clipboard" }),
	},

	-- Ctrl + Left-click to open link
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},

	-- Window drag with Super or Ctrl + Shift + Left-click
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "LEADER",
		action = wezterm.action.StartWindowDrag,
	},
}

-- Other settings
config.enable_scroll_bar = false
config.scrollback_lines = 1000 -- Default is 3500, reduce to speed up
config.audible_bell = "Disabled"
config.max_fps = 240
config.front_end = "WebGpu"

-- Optional: Configure some additional GPU-related optimizations
config.freetype_load_target = "Light" -- Font rendering optimization

return config
