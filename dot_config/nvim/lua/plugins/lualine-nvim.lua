-- Function to get Codeium status
local function get_codeium_status()
	local ok, status = pcall(vim.api.nvim_call_function, "codeium#GetStatusString", {})
	return ok and status or ""
end

local config = function()
	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "|", right = "|" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = true,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {
				"filename",
				-- path = 2, -- 0: Just the filename
				-- -- 1: Relative path
				-- -- 2: Absolute path
				-- -- 3: Absolute path, with tilde as the home directory
				-- -- 4: Filename and parent dir, with tilde as the home directory
				--
				-- -- for other components. (terrible name, any suggestions?)
				-- symbols = {
				-- 	modified = "[+]", -- Text to show when the file is modified.
				-- 	readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
				-- 	unnamed = "[No Name]", -- Text to show for unnamed buffers.
				-- 	newfile = "[New]", -- Text to show for newly created file before first write
				-- },
			},

			lualine_x = { get_codeium_status, "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	config = config,
}
