local wezterm = require("wezterm")
local act = wezterm.action

local config = {

	-- Import configurations from other files
	-- keys = require("keybindings"),
	disable_default_key_bindings = false,
	font = require("fonts"),
	color_scheme = "Tokyo Night",

	-- Font rendering (Mac-like crispness on Windows)
	font_size = 13,
	line_height = 1.15,
	cell_width = 1.0,
	-- FreeType: grayscale hinting (Normal) for glyph-shape accuracy, subpixel
	-- rendering (HorizontalLcd) for perceived horizontal resolution on
	-- QD-OLED's RGB subpixels. Best "Mac-like on Windows" recipe.
	freetype_load_target = "Normal",
	freetype_render_target = "HorizontalLcd",
	harfbuzz_features = { "calt=1", "liga=1", "dlig=1", "ss01=1" },

	-- Appearance settings
	-- hide_tab_bar_if_only_one_tab = false, -- Disabled: using herdr
	-- tab_bar_at_bottom = true, -- Disabled: using herdr
	-- use_fancy_tab_bar = true, -- Disabled: herdr
	enable_tab_bar = false, -- Disable WezTerm tabs entirely.
	audible_bell = "Disabled",
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE", -- Remove the title bar
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	initial_rows = 30,
	initial_cols = 100,
	enable_scroll_bar = false,
	scrollback_lines = 5000,
	enable_kitty_keyboard = false,
	enable_csi_u_key_encoding = false,
	front_end = "WebGpu",
	max_fps = 240,

	-- Window frame chrome (kept minimal)
	window_frame = {
		font_size = 11,
	},

	default_workspace = "default",
	-- status_update_interval = 1000, -- Disabled: using Zellij status
	mux_enable_ssh_agent = false,
}

-- Auto-select the best available GPU adapter
local gpus = wezterm.gui.enumerate_gpus()
local selected_gpu = nil

-- 1st preference: discrete GPU with Vulkan
for _, gpu in ipairs(gpus) do
	if gpu.device_type == "DiscreteGpu" and gpu.backend == "Vulkan" then
		selected_gpu = gpu
		break
	end
end

-- 2nd preference: any discrete GPU
if not selected_gpu then
	for _, gpu in ipairs(gpus) do
		if gpu.device_type == "DiscreteGpu" then
			selected_gpu = gpu
			break
		end
	end
end

-- 3rd preference: any Vulkan GPU
if not selected_gpu then
	for _, gpu in ipairs(gpus) do
		if gpu.backend == "Vulkan" then
			selected_gpu = gpu
			break
		end
	end
end

-- Final fallback: first available GPU
if not selected_gpu and #gpus > 0 then
	selected_gpu = gpus[1]
end

if selected_gpu then
	config.webgpu_preferred_adapter = selected_gpu
	if selected_gpu.device_type == "DiscreteGpu" then
		config.webgpu_power_preference = "HighPerformance"
	end
	wezterm.log_info(string.format("Selected GPU: %s [%s, %s]", selected_gpu.name, selected_gpu.backend, selected_gpu.device_type))
else
	wezterm.log_warn("No GPU found; using WebGPU default")
end

-- Pick default shell by OS
if wezterm.target_triple:find("windows") then
	local home = os.getenv("USERPROFILE")
	config.default_prog = {
		home .. "/scoop/shims/pwsh.exe",
		"-NoLogo",
	}
else
	config.default_prog = { "/bin/zsh", "-l" }
	config.window_background_opacity = 0.85 -- Transparency on Linux/macOS
	config.text_background_opacity = 0.5
end

config.keys = {}

return config
