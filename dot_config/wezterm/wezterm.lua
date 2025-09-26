local wezterm = require("wezterm")
local act = wezterm.action
local detect_os

print(detect_os)
local function shell_escape(path)
	-- simple quoting for bash/PowerShell
	if detect_os() == "windows" then
		return '"' .. (path or "") .. '"'
	else
		-- escape single quotes for POSIX shells
		return "'" .. ((path or ""):gsub("'", "'\\''")) .. "'"
	end
end

local function run_capture(cmd)
	-- run a shell command and return trimmed stdout (nil on failure/empty)
	local f = io.popen(cmd)
	if not f then
		return nil
	end
	local s = f:read("*a")
	f:close()
	if not s or s == "" then
		return nil
	end
	-- trim trailing whitespace/newlines
	return (s:gsub("%s+$", ""))
end

local function detect_project_root()
	-- Try git top-level
	local git_root = run_capture("git rev-parse --show-toplevel 2>/dev/null")
	if git_root and git_root ~= "" then
		return git_root
	end
	-- Fall back to environment-specified project path
	local env_proj = os.getenv("WEZTERM_PROJECT")
	if env_proj and env_proj ~= "" then
		return env_proj
	end
	-- final fallback to HOME or current directory
	return os.getenv("HOME") or "."
end

local function repo_name_from_root(root)
	if not root or root == "" then
		return "python"
	end
	-- Use basename; prefer POSIX basename; handles typical cases.
	local name = run_capture("basename " .. shell_escape(root) .. " 2>/dev/null")
	if name and name ~= "" then
		return name
	end
	-- fallback
	return "python"
end

local function shell_for_os()
	if detect_os() == "windows" then
		-- PowerShell; -NoLogo to avoid startup noise
		return { "pwsh", "-NoLogo", "-Command" }
	else
		-- POSIX shell
		return { "bash", "-lc" }
	end
end

local function build_args_with_shell(base_cmd)
	-- returns an args table suitable for spawn_window() where the last element is the command string
	local shell = shell_for_os()
	local t = {}
	for i = 1, #shell do
		t[#t + 1] = shell[i]
	end
	t[#t + 1] = base_cmd
	return t
end

local function ensure_python_workspace(gui_window)
	-- Create a project-aware python workspace:
	-- left: nvim in project root
	-- right-top: interactive REPL (ptpython/ipython via poetry if available)
	-- right-bottom: tests/dev-server (pytest or uvicorn), best-effort
	local mux = wezterm.mux
	if mux == nil then
		-- GUI process / mux not available: just switch to a generic workspace
		gui_window:perform_action(act.SwitchToWorkspace({ name = "python" }), gui_window)
		return
	end

	-- detect project root and repo name
	local project_root = detect_project_root()
	local repo = repo_name_from_root(project_root)
	local ws_name = "python:" .. repo

	-- If workspace already has a window, switch to it
	for _, w in ipairs(mux.get_windows()) do
		if w:active_workspace() == ws_name then
			gui_window:perform_action(act.SwitchToWorkspace({ name = ws_name }), gui_window)
			return
		end
	end

	-- Ensure we have a sane cwd
	local cwd = project_root or "."

	-- Left pane: nvim in project root
	local nvim_cmd
	if detect_os() == "windows" then
		-- PowerShell: cd and run nvim
		nvim_cmd = "Set-Location -LiteralPath " .. shell_escape(cwd) .. " ; nvim"
	else
		nvim_cmd = "cd " .. shell_escape(cwd) .. " && nvim"
	end

	local tab, left_pane, new_window = mux.spawn_window({
		workspace = ws_name,
		cwd = cwd,
		args = build_args_with_shell(nvim_cmd),
	})

	-- Right-top: interactive REPL (prefer poetry-managed env if present)
	local repl_cmd
	if detect_os() == "windows" then
		repl_cmd = "Set-Location -LiteralPath "
			.. shell_escape(cwd)
			.. " ; (poetry run ptpython -q 2>$null -or poetry run ipython -q 2>$null -or ptpython -q 2>$null -or ipython -q)"
	else
		repl_cmd = "cd "
			.. shell_escape(cwd)
			.. " && (poetry run ptpython || poetry run ipython || ptpython || ipython)"
	end

	local right_top = left_pane:split({
		direction = "Right",
		size = 0.5,
		cwd = cwd,
		args = build_args_with_shell(repl_cmd),
	})

	-- Right-bottom: run tests or dev server (try pytest, then uvicorn, otherwise leave a shell)
	local test_cmd
	if detect_os() == "windows" then
		test_cmd = "Set-Location -LiteralPath "
			.. shell_escape(cwd)
			.. " ; (poetry run pytest -q --maxfail=1 2>$null -or pytest -q 2>$null -or poetry run uvicorn app:app --reload 2>$null -or Write-Host 'No test or server detected'; Start-Sleep -Seconds 1)"
	else
		test_cmd = "cd "
			.. shell_escape(cwd)
			.. " && (poetry run pytest -q --maxfail=1 || pytest -q || poetry run uvicorn app:app --reload || echo 'No test or server detected')"
	end

	right_top:split({
		direction = "Down",
		size = 0.5,
		cwd = cwd,
		args = build_args_with_shell(test_cmd),
	})

	-- Finally switch the GUI to the newly-created workspace
	gui_window:perform_action(act.SwitchToWorkspace({ name = ws_name }), gui_window)
end

detect_os = function()
	local target = wezterm.target_triple or ""
	if target:find("windows") then
		return "windows"
	elseif target:find("darwin") then
		return "macos"
	else
		return "linux"
	end
end

local computer_name = os.getenv("COMPUTERNAME") or os.getenv("HOSTNAME")

local config = {
	-- Import configurations from other files
	keys = require("keybindings"),
	font = require("fonts"),
	color_scheme = require("colors"),
	-- Appearance settings
	hide_tab_bar_if_only_one_tab = false, -- Hide the tab bar if there's only one tab
	tab_bar_at_bottom = true, -- Move the tab bar to the bottom
	use_fancy_tab_bar = false, -- Enable fancy tab bar
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", -- Remove the title bar
	window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	},
	initial_rows = 30,
	initial_cols = 100,
	enable_scroll_bar = true, -- Enable scroll bar
	scrollback_lines = 5000,
	front_end = "WebGpu",
	-- webgpu_preferred_adapter = (function()
	-- 	if computer_name == "Azin-Desktop" then
	-- 		return {
	-- 			backend = "Vulkan",
	-- 			device_type = "DiscreteGpu",
	-- 			name = "NVIDIA GeForce RTX 4070 SUPER",
	-- 		}
	-- 	elseif computer_name == "Machine2" then
	-- 		return {
	-- 			backend = "Vulkan",
	-- 			device_type = "DiscreteGpu",
	-- 			name = "Another GPU Name",
	-- 		}
	-- 	else
	-- 		return {
	-- 			backend = "Vulkan",
	-- 			device_type = "DiscreteGpu",
	-- 			name = "Default GPU Name",
	-- 		}
	-- 	end
	-- end)(),
	max_fps = 240,
	window_background_opacity = 0.8,
	text_background_opacity = 0.8,
	default_workspace = "default",
	status_update_interval = 1000,
}
if detect_os() == "windows" then
	config.default_prog = { "pwsh" }
elseif detect_os() == "macos" then
	config.default_prog = { "/bin/zsh" }
end

-- switch to workspace
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

config.keys = {
	-- Switch to the default workspace
	{
		key = "y",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "default",
		}),
	},
	-- Switch to a monitoring workspace, which will have `top` launched into it
	{
		key = "b",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "monitoring",
			spawn = {
				args = { "btop" },
			},
		}),
	},

	-- Show the launcher in fuzzy selection mode and have it list all workspaces
	-- and allow activating one.
	{
		key = "0",
		mods = "CTRL",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES|TABS",
		}),
	},
	{ key = "m", mods = "CTRL|SHIFT", action = wezterm.action.ShowLauncher },
	-- Create/switch to the python workspace (left: nvim; right-top: ai-openai; right-bottom: yazi)
	{
		key = "i",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			ensure_python_workspace(win)
		end),
	},
}

return config
