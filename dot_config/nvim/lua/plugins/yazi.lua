return {
	"DreamMaoMao/yazi.nvim",
	lazy = False,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},

	keys = {
		{ "<leader>gy", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
	},
}
