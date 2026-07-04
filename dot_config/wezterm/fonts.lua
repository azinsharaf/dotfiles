local wezterm = require 'wezterm'

return wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = "Regular", italic = false },
	{ family = "Atkinson Hyperlegible Mono", weight = "Regular" },
})
