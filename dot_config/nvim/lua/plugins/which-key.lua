return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		delay = 0,
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
		{
			"<leader>e",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Explorer",
		},
		{
			"<leader>f",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Find",
		},
		{
			"<leader>h",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Git Hunk",
		},
		{
			"<leader>o",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Obsidian",
		},
		{
			"<leader>s",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Split",
		},
	},
}
