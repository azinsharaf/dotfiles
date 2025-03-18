local wezterm = require("wezterm")
local act = wezterm.action
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"

local function mergeTables(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end
end

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local theme = require("colors/kanagawa_dragon")

local config = {
	default_prog = is_windows and { "pwsh", "-NoLogo" } or { "zsh" }, -- Set default shell
	default_workspace = "~",
	font = wezterm.font_with_fallback({
		"FiraCode Nerd Font", -- Primary font
		"JetBrainsMono Nerd Font",
		"Noto Color Emoji", -- Emoji fallback
		"Symbola", -- For rare symbols
		"DejaVu Sans", -- Additional fallback
	}),
	-- font = wezterm.font("Hack Nerd Font"),
	font_size = 10,

	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	hide_tab_bar_if_only_one_tab = false,
	hide_mouse_cursor_when_typing = true,
	inactive_pane_hsb = {
		brightness = 0.9,
	},
	scrollback_lines = 5000,
	audible_bell = "Disabled",
	enable_scroll_bar = false,

	initial_cols = 200,
	initial_rows = 50,
	window_background_opacity = 0.95,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	tab_max_width = 32,
	switch_to_last_active_tab_when_closing_tab = true,
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	integrated_title_buttons = { "Hide", "Maximize", "Close" },
	integrated_title_button_style = "Windows",
	integrated_title_button_alignment = "Right",
	integrated_title_button_color = "Auto",

	status_update_interval = 1000,

	colors = theme,

	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{
			key = "h",
			mods = "LEADER",
			action = wezterm.action.SplitPane({
				direction = "Down",
				size = { Percent = 30 },
			}),
		},
		{
			key = "v",
			mods = "LEADER",
			action = wezterm.action.SplitPane({
				direction = "Right",
				size = { Percent = 50 },
			}),
		},
		{
			key = "z",
			mods = "LEADER",
			action = wezterm.action.TogglePaneZoomState,
		},
		{
			key = "t",
			mods = "LEADER",
			action = act.SpawnTab("CurrentPaneDomain"),
		},
		{ key = "X", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
		{ key = "L", mods = "CTRL|SHIFT|ALT", action = wezterm.action.ShowDebugOverlay },

		{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
		{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
			end),
		},
		{
			key = "W",
			mods = "LEADER",
			action = resurrect.window_state.save_window_action(),
		},
		{
			key = "T",
			mods = "LEADER",
			action = resurrect.tab_state.save_tab_action(),
		},
		{
			key = "s",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
				resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
				resurrect.window_state.save_window_action()
			end),
		},

		{
			key = "r",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
				resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
					local type = string.match(id, "^([^/]+)") -- match before '/'
					id = string.match(id, "([^/]+)$") -- match after '/'
					id = string.match(id, "(.+)%..+$") -- remove file extention
					local opts = {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					}
					if type == "workspace" then
						local state = resurrect.state_manager.load_state(id, "workspace")
						resurrect.workspace_state.restore_workspace(state, opts)
					elseif type == "window" then
						local state = resurrect.state_manager.load_state(id, "window")
						resurrect.window_state.restore_window(pane:window(), state, opts)
					elseif type == "tab" then
						local state = resurrect.state_manager.load_state(id, "tab")
						resurrect.tab_state.restore_tab(pane:tab(), state, opts)
					end
				end)
			end),
		},
	},
	mouse_bindings = {
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
	},
}

return config
