return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{
			"nvim-tree/nvim-web-devicons",
		},

		{
			"nvim-telescope/telescope-ui-select.nvim",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, --move to prev result
						["<C-j>"] = actions.move_selection_next, --move to next result
					},
				},
			},
			extensions = {
				file_browser = {
					hidden = { file_browser = true, folder_browser = true },
					display_stat = { date = true, size = true, mode = true },
				},

				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		})

		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")

		-- set keymaps

		local keymap = vim.keymap

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "files" })
		keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "old files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "grep a word" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "string under cursor in cwd" })
		-- keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fc", telescope.extensions.chezmoi.find_files, { desc = "chezmoi files" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser hidden=true<cr>", { desc = "browser" })
		keymap.set("n", "<leader>fx", "<cmd>Telescope buffers<cr>", { desc = "buffers" })
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "help Tags" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>", { desc = "registers" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope spell_suggest<cr>", { desc = "spell suggestions" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "key maps" })
	end,
}
