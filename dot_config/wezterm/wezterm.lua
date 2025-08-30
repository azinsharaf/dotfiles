local wezterm = require("wezterm")

local keybindings = require("keybindings")
local theme = require("theme")

return {
	leader = keybindings.leader,
	keys = keybindings.keys,
	-- Add theme settings if any
	-- color_scheme = theme.color_scheme,
}
