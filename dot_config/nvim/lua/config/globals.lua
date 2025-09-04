vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.g.lsp_handlers_enabled = false
vim.g.matchup_matchparen_deferred = 1
vim.g.highlightedyank_highlight_duration = 200

-- Get the computer name dynamically
local computer_name = vim.loop.os_gethostname()

-- Define paths for each computer that has pynvim installed
local python_paths = {
	["Azin-Desktop"] = "C:/Users/azin/.pyenv/pyenv-win/versions/3.12.8/env-pynvim/Scripts/python.exe",
	["ws-oak512-007"] = "C:/Users/asharaf/.pyenv/pyenv-win/versions/3.12.8/env-pynvim/Scripts/python.exe",
	["Azin-Macbook"] = "~/Library/Python/3.12/bin/python3",
}

-- Set the Python 3 host program based on the computer name

vim.g.python3_host_prog = python_paths[computer_name] or "/usr/bin/python3" -- Default fallback

vim.deprecate = function() end
