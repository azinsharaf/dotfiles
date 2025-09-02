local wezterm = require("wezterm")

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

local config = {
	-- Import configurations from other files
	keys = require("keybindings"),
	font = require("fonts"),
	color_scheme = require("colors"),
	-- Appearance settings
	hide_tab_bar_if_only_one_tab = true, -- Hide the tab bar if there's only one tab
	tab_bar_at_bottom = true, -- Move the tab bar to the bottom
	use_fancy_tab_bar = true, -- Enable fancy tab bar
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
}

if detect_os() == "windows" then
	config.default_prog = { "pwsh" }
end

return config
