local wezterm = require("wezterm")
local workspace_picker = wezterm.plugin.require("https://github.com/bugii/workspace-picker-plugin")

local home = os.getenv("HOME") or os.getenv("USERPROFILE") or ""

local function expand(p)
	if p:sub(1, 2) == "~/" then
		return home .. p:sub(2)
	end
	return p
end

local function deepcopy(t)
	if type(t) ~= "table" then
		return t
	end
	local u = {}
	for k, v in pairs(t) do
		u[k] = deepcopy(v)
	end
	return u
end

-- Put your list of repo/folder paths here (can be full paths or "~/"-prefixed)
local repos = {
	"~/repos/geopeek",
	"~/repos/alameda_gis_azure_maintenance",
	"~/repos/belmont_dmp_gis_maintenance",
	"~/repos/danville_dmp_gis_maintenance",
	"~/repos/dmp_inspection_report_generator",
	"~/repos/glendale_dmp_gis_maintenance",
	"~/repos/jn3614008_knights_landing",
	"~/repos/la_county_dmp_gis_maintenance",
	"~/repos/port_of_oakland_gis_maintenance",
	"~/repos/Processing_NOAA_AORC_NEXRAD",
	"~/repos/sde_creation",
	"~/repos/sdmp_condassess_rehabplan_script",
	"~/repos/wr_gis_icm",
	"~/repos/wri_gis_oakland_misc_tools",
	"~/repos/wri_gis_pythontoolbox",
	"~/repos/wri_gis_sdmppostprocessing",
	"~/repos/wri_gis_watersheds",
	"~/repos/wri_gis_weightedaverage",
	"~/repos/wri_sdmp_gis_tools",
	"~/.local/share/chezmoi",
}

-- Shared tab/pane template
local tabs_template = {
	{
		name = "editor",
		direction = "Right",
		panes = {
			{
				name = "nvim",
				command = "ca && nvim",
				direction = "Right",
				size = 2,
			},
			{
				name = "run",
				command = "ca && clear",
				direction = "Right",
				size = 1,
			},
		},
	},
	{ name = "ai", command = "opencode" },
	{ name = "git", command = "lazygit" },
	{ name = "yazi", command = "yazi" },
	{
		name = "notes",
		command = "cd '~/OneDrive - Wood Rodgers Inc/5 - azin_obsidian_work/' && nvim",
	},
	{ name = "btop", command = " btop" },
}

-- Ensure tabs inherit a human-readable title from the template `name`
for _, t in ipairs(tabs_template) do
	if not t.tab_title and t.name then
		t.tab_title = t.name
	end
end

-- Build workspaces from repos list
local workspaces = {}
for _, raw in ipairs(repos) do
	local path = expand(raw)
	local tabs = deepcopy(tabs_template)

	-- Prefix `cd` to commands so panes/tabs start in the correct folder,
	-- but skip if the command already contains a `cd`.
	for _, tab in ipairs(tabs) do
		if tab.panes then
			for _, pane in ipairs(tab.panes) do
				if pane.command and not pane.command:match("^%s*cd%s+") then
					pane.command = string.format("cd %q && %s", path, pane.command)
				end
			end
		else
			if tab.command and not tab.command:match("^%s*cd%s+") then
				tab.command = string.format("cd %q && %s", path, tab.command)
			end
		end
	end

	table.insert(workspaces, {
		path = path,
		type = "directory",
		tabs = tabs,
	})
end

workspace_picker.setup(workspaces, {
	icons = {
		directory = "📁",
		worktree = "🌳",
		zoxide = "⚡",
		workspace = "🖥️",
	},
})

-- Apply to config with custom keybinding
local M = {}

-- load local tabline helper so tab formatting is consistent
local tabline = dofile(wezterm.config_dir .. "/tabline.lua")

function M.apply(config)
	-- Ensure each tab uses its template `name` as `tab_title` before plugin creates tabs
	for _, ws in ipairs(workspaces) do
		if ws.tabs then
			for _, t in ipairs(ws.tabs) do
				if t.name then
					t.tab_title = t.name
				end
			end
		end
	end

	workspace_picker.apply_to_config(config, "f", "CTRL")
	-- apply tabline plugin formatting
	if tabline and tabline.apply then
		tabline.apply(config)
	end
end

return M
