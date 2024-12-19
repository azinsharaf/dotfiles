-- Mouse bindings
local wezterm = require("wezterm")
return {
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
