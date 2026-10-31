return {
	"echasnovski/mini.snippets",
	event = "VeryLazy",
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = function()
		local gen_loader = require("mini.snippets").gen_loader
		require("mini.snippets").setup({
			snippets = { gen_loader.from_lang() },
		})
	end,
}
