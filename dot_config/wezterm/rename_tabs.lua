-- renametab.lua
local wezterm = require("wezterm")

local M = {}

-- List of tab names
local tab_names = { "server", "editor", "logs", "tests", "notes", "misc" }

-- Function to rename all tabs
local function rename_tabs(window, pane)
    local tabs = window:mux_window():tabs()
    for i, tab in ipairs(tabs) do
        local name = tab_names[i]
        if name then
            tab:set_title(name)
        end
    end
end

-- Register event
wezterm.on("rename_tabs_from_list", rename_tabs)

-- Export a function that returns the keybinding
function M.get_keybinding()
    return {
        key = "R",
        mods = "CTRL|SHIFT",
        action = wezterm.action.EmitEvent("rename_tabs_from_list"),
    }
end

return M
