return {
	"nvzone/typr",
	enabled = true,
	dependencies = "nvzone/volt",
	opts = {},
	cmd = { "Typr", "TyprStats" },
	keys = {
		{
			"<leader>tt",
			mode = "n",
			"<cmd>Typr<CR>",
			desc = "Typr",
		},
		{
			"<leader>ts",
			mode = "n",
			"<cmd>TyprStats<CR>",
			desc = "Typr Stats",
		},
	},
}
