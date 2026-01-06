return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		},
		config = function(_, opts)
			local harpoon = require("harpoon")
			harpoon:setup(opts)
		end,
		keys = {
			{
				"<leader>ha",
				function()
					local harpoon = require("harpoon")
					harpoon:list():add()
				end,
				desc = "Harpoon add file",
				mode = "n",
			},
			{
				"<TAB>",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon menu",
				mode = "n",
			},
			{
				"<leader>h1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon to 1",
				mode = "n",
			},
			{
				"<leader>h2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Harpoon to 2",
				mode = "n",
			},
			{
				"<leader>h3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Harpoon to 3",
				mode = "n",
			},
			{
				"<leader>h4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Harpoon to 4",
				mode = "n",
			},
			{
				"<leader>hn",
				function()
					require("harpoon"):list():next()
				end,
				desc = "Harpoon next",
				mode = "n",
			},
			{
				"<leader>hp",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "Harpoon prev",
				mode = "n",
			},
		},
	},
	{
		"catppuccin/nvim",
		optional = true,
		-- @type CatppuccinOptions
		opts = { integrations = { harpoon = true } },
	},
}
