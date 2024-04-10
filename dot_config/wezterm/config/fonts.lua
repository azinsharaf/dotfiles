local wezterm = require("wezterm")
local platform = require("utils.platform")

-- local font = "FiraCode Nerd Font"
local font = "JetBrainsMono Nerd Font"
local font_size = 11 --platform().is_mac and 12 or 13

return {

	warn_about_missing_glyphs = false,
	font = wezterm.font(font, { weight = "DemiBold" }),
	font_size = font_size,

	--ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
	freetype_load_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
	freetype_render_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
