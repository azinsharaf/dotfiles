return {
	"nvzone/typr",
	enabled = true,
	dependencies = "nvzone/volt",
	opts = {},
	cmd = { "Typr", "TyprStats" },
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
	},
}
