return {
	"folke/which-key.nvim",
	event = "VimEnter", -- VeryLazy",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").register({
			["<leader>e"] = { name = "[e]xplorer", _ = "which_key_ignore" },
			["<leader>f"] = { name = "[f]ile", _ = "which_key_ignore" },
			["<leader>h"] = { name = "git [h]unks", _ = "which_key_ignore" },
			["<leader>o"] = { name = "[o]bsidian", _ = "which_key_ignore" },
			["<leader>p"] = { name = "[p]ackages", _ = "which_key_ignore" },
			["<leader>s"] = { name = "[s]plit", _ = "which_key_ignore" },
			["<leader>w"] = { name = "[w]orkspaces", _ = "which_key_ignore" },
		})
	end,
}
