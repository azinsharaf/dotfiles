local wezterm = require("wezterm")

local keybindings = require("keybindings")
local theme = require("theme")

return {
	leader = keybindings.leader,
	keys = keybindings.keys,
	default_prog = { "pwsh" }, -- Set PowerShell as the default shell
	color_scheme = theme.color_scheme, -- Ensure this line is uncommented
}
