local wezterm = require("wezterm")

local function detect_os()
	local target = wezterm.target_triple
	if target:find("windows") then
		return "windows"
	elseif target:find("darwin") then
		return "macos"
	end
end

if detect_os() == "macos" then
	config.default_prog = { "/bin/zsh" }
end

local computer_name = os.getenv("COMPUTERNAME") or os.getenv("HOSTNAME")

local config = {
	-- Import configurations from other files
	keys = require("keybindings"),
	font = require("fonts"),
	color_scheme = require("colors"),
	-- Appearance settings
	hide_tab_bar_if_only_one_tab = true, -- Hide the tab bar if there's only one tab
	tab_bar_at_bottom = true, -- Move the tab bar to the bottom
	use_fancy_tab_bar = true, -- Enable fancy tab bar
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
	-- front_end = "WebGpu",
	-- webgpu_power_preference = "HighPerformance",
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
}
if detect_os() == "windows" then
	config.default_prog = { "pwsh" }
end

return config
