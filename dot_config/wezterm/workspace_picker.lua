local wezterm = require("wezterm")
local picker = wezterm.plugin.require("https://github.com/bugii/workspace-picker-plugin")

local home = os.getenv("HOME") or os.getenv("USERPROFILE") or ""

local function expand(path)
	if path:sub(1, 2) == "~/" then
		return home .. path:sub(2)
	end
	return path
end

local function deepcopy(value)
	if type(value) ~= "table" then
		return value
	end
	local copy = {}
	for key, item in pairs(value) do
		copy[key] = deepcopy(item)
	end
	return copy
end

-- Put your list of repo/folder paths here (can be full paths or "~/"-prefixed)
local repos = {
	"~",
	"~/repos/geopeek",
	"~/repos/resume",
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
				name = "pane1",
				command = "ca && clear",
				direction = "Right",
				size = 1,
			},
			{
				name = "pane2",
				command = "ca && nvim",
				direction = "Right",
				size = 2,
			},
			{
				name = "pane3",
				command = "ca && clear",
				direction = "Right",
				size = 1,
			},
		},
	},
	{ name = "ai", command = "opencode" },
	{ name = "git", command = "lazygit" },
	{ name = "yazi", command = "yazi" },
	{ name = "notes", command = "cd '~/OneDrive - Wood Rodgers Inc/5 - azin_obsidian_work/' && nvim" },
	{ name = "shell", command = "cd ~" },
	{ name = "btop", command = "btop" },
	{ name = "music", command = "spotify_player" },
}

-- Ensure tabs inherit a human-readable title from the template `name`
for _, tab in ipairs(tabs_template) do
	if not tab.tab_title and tab.name then
		tab.tab_title = tab.name
	end
end

local function build_workspaces()
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
	return workspaces
end

local default_options = {
	icons = {
		directory = "📁",
		worktree = "🌳",
		zoxide = "⚡",
		workspace = "🖥️",
	},
}
local configured = false

local function ensure_setup()
	if configured then
		return
	end
	picker.setup(build_workspaces(), default_options)
	configured = true
end

local M = {}

function M.apply(config, key, mods)
	ensure_setup()
	picker.apply_to_config(config, key, mods)
end

function M.switch_to_workspace(path)
	ensure_setup()
	return picker.switch_to_workspace(expand(path))
end

function M.setup(workspaces, options)
	picker.setup(workspaces, options or default_options)
	configured = true
end

function M.ensure_setup()
	ensure_setup()
end

return M
