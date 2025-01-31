return {
	"olimorris/codecompanion.nvim",
	enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},

	require("codecompanion").setup({
		strategies = {
			chat = {
				adapter = "openai",
			},
			inline = {
				adapter = "openai",
			},
		},
		adapters = {
			openai = function()
				return require("codecompanion.adapters").extend("openai", {
					env = {
						api_key = os.getenv("OPENAI_API_KEY"),
					},
				})
			end,
		},
	}),
}
