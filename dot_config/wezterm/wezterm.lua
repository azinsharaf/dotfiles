-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size, font, and color scheme.
config.font_size = 10
config.color_scheme = "AdventureTime"

-- Specify the font
config.font = wezterm.font("JetBrains Mono Nerd Font")

-- Set PowerShell as the default shell
config.default_prog = { "pwsh" }
return config
