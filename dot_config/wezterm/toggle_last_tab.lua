local wezterm = require("wezterm")
local act = wezterm.action

-- maintain MRU (most-recently-used) list of tabs per window
local tab_history = {}

wezterm.on("active-tab-changed", function(window, tab)
	local id = window:window_id()
	tab_history[id] = tab_history[id] or { mru = {}, ignore = false }
	local h = tab_history[id]
	-- if this change was triggered by our own programmatic switch, consume the flag and do not reorder
	if h.ignore then
		h.ignore = false
		return
	end
	local idx = tab.tab_index
	-- remove existing occurrence of idx in mru
	for i = #h.mru, 1, -1 do
		if h.mru[i] == idx then
			table.remove(h.mru, i)
			break
		end
	end
	-- insert at front
	table.insert(h.mru, 1, idx)
	-- keep list reasonably small (optional)
	if #h.mru > 20 then
		table.remove(h.mru)
	end
end)

-- toggle-binding: switch to the most-recently-used tab (second entry in MRU list)
local toggle_binding = {
	key = "Tab",
	mods = "CTRL|SHIFT",
	action = act.Callback(function(window, pane)
		local id = window:window_id()
		local h = tab_history[id]
		if not h or #h.mru < 2 then
			return
		end
		local target = h.mru[2]
		-- rotate MRU order so repeated toggles alternate between mru[1] and mru[2]
		h.mru[2] = h.mru[1]
		h.mru[1] = target
		h.ignore = true
		window:activate_tab(target)
	end),
}

return toggle_binding

