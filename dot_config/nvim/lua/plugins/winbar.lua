return {
	"fgheng/winbar.nvim",
	enabled = true,
	config = function()
		require("winbar").setup({
			show_file_path = false,
			show_symbols = true,
			colors = {
				path = "", -- You can customize colors like #c946fd
				file_name = "",
				symbols = "",
			},

			icons = {
				file_icon_default = "",
				seperator = ">",
				editor_state = "●",
				lock_icon = "",
			},

			exclude_filetype = {
				"", -- for wilder.nvim plugin
				"help",
				"startify",
				"dashboard",
				"packer",
				"neogitstatus",
				"NvimTree",
				"Trouble",
				"alpha",
				"lir",
				"Outline",
				"spectre_panel",
				"toggleterm",
				"qf",
			},
		})
	end,
}
