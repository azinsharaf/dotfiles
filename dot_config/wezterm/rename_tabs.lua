-- renametab.lua
local wezterm = require("wezterm")

local M = {}

-- List of tab names (left-to-right order)
local tab_names = { "editor", "ai", "git", "yazi", "notes", "btop" }

-- Function to rename all tabs
local function rename_tabs(window, pane)
	if not window then
		wezterm.log_error("rename_tabs_from_list: missing window reference")
		return
	end

	local mux_window = window:mux_window()
	if not mux_window then
		wezterm.log_error("rename_tabs_from_list: unable to resolve mux window")
		return
	end

	local tabs = mux_window:tabs()
	wezterm.log_info(string.format(
		"rename_tabs_from_list triggered (window=%s pane=%s tabs=%d)",
		window:window_id() or "?",
		pane and pane:pane_id() or "?",
		#tabs
	))

	if #tabs == 0 then
		wezterm.log_info("rename_tabs_from_list: no tabs to rename")
		return
	end

	for i, tab in ipairs(tabs) do
		local name = tab_names[i] or string.format("tab %d", i)
		wezterm.log_info(string.format("rename_tabs_from_list: tab[%d] -> '%s'", i, name))
		tab:set_title(name)
	end
end

-- Register event
wezterm.on("rename_tabs_from_list", rename_tabs)

-- Export a function that returns the keybinding
function M.get_keybinding()
	return {
		key = "E",
		mods = "CTRL|SHIFT",
		action = wezterm.action.EmitEvent("rename_tabs_from_list"),
	}
end

return M
