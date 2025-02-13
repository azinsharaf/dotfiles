local wezterm = require("wezterm")
-- local mux = wezterm.mux

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
	-- font = wezterm.font("JetBrainsMono Nerd Font"),
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
	keys = require("keybinds"),
	mouse_bindings = require("mousebinds"),
}

return config
