-- Softened Tokyo Night palette for WezTerm
-- Tokyo Night at full saturation is loud on OLED; FG/backgrounds are pulled back
-- so transparent windows don't look muddy and the contrast doesn't blow out.
-- This returns a `color_schemes` table; `color_scheme` (singular) references
-- the entry by name from `wezterm.lua`.

return {
	["tokyonight-soft"] = {
		foreground   = "#a9b1d6",
		background   = "#1a1b26",
		cursor_bg    = "#7aa2f7",
		cursor_fg    = "#1a1b26",
		selection_bg = "#283457",
		selection_fg = "#c0caf5",

		ansi = {
			"#15161e", -- black
			"#f7768e", -- red
			"#9ece6a", -- green
			"#e0af68", -- yellow
			"#7aa2f7", -- blue
			"#bb9af7", -- magenta
			"#7dcfff", -- cyan
			"#a9b1d6", -- white
		},
		brights = {
			"#414868", -- bright black
			"#ff7a93", -- bright red
			"#b9f27c", -- bright green
			"#ff9e64", -- bright yellow
			"#7da6ff", -- bright blue
			"#d0aaff", -- bright magenta
			"#a4ffff", -- bright cyan
			"#c0caf5", -- bright white
		},
	},
}
