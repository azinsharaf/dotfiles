local wezterm = require("wezterm")

-- Theme settings
local theme = {
	-- Add your theme settings here
	-- Example:
	-- color_scheme = "Dracula",
}

-- Keybindings
local keybindings = {
	leader = { key = "a", mods = "CTRL" },
	keys = {
		-- Test leader key
		{ key = "t", mods = "LEADER", action = wezterm.action({ EmitEvent = "leader-test" }) },

		-- Use leader key for activating pane navigation
		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

		-- Split pane horizontally
		{
			key = "-",
			mods = "LEADER",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},

		-- Split pane vertically
		{
			key = "v",
			mods = "CTRL|LEADER",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},

		-- Move between panes
		{ key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

		-- Copy and paste
		{ key = "c", mods = "CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "v", mods = "CTRL|LEADER", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	},
}

wezterm.on("leader-test", function(window, pane)
	window:toast_notification("Leader Key Test", "Leader key is working!", nil, 5000)
end)

return {
	leader = keybindings.leader,
	keys = keybindings.keys,
	default_prog = { "pwsh" }, -- Set PowerShell as the default shell
	color_scheme = theme.color_scheme, -- Ensure this line is uncommented
	window_decorations = "RESIZE", -- Remove header, keep resize
}
