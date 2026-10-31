return {
	{
		"lewis6991/gitsigns.nvim",
		enabled = true,
		event = "VeryLazy",
		config = function()
			-- local icons = require('config.icons')
			require("gitsigns").setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged_enable = true,
				signcolumn = true,
				numhl = false,
				linehl = false,
				word_diff = false,
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 200,
				status_formatter = nil,
				max_file_length = 40000,
				preview_config = {
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},

				on_attach = function(bufnr)
					vim.keymap.set(
						"n",
						"<leader>H",
						require("gitsigns").preview_hunk,
						{ buffer = bufnr, desc = "Preview git hunk" }
					)

					vim.keymap.set("n", "]]", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Next git hunk" })

					vim.keymap.set(
						"n",
						"[[",
						require("gitsigns").prev_hunk,
						{ buffer = bufnr, desc = "Previous git hunk" }
					)
				end,
			})
		end,
		keys = {
			{
				"<leader>gl",
				function()
					require("gitsigns").next_hunk({ navigation_message = false })
				end,
				desc = "Next Hunk",
			},
			{
				"<leader>gh",
				function()
					require("gitsigns").prev_hunk({ navigation_message = false })
				end,
				desc = "Prev Hunk",
			},
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line()
				end,
				desc = "Blame",
			},
			{
				"<leader>gp",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Preview Hunk",
			},
			{
				"<leader>gr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Reset Hunk",
			},
			{
				"<leader>gR",
				function()
					require("gitsigns").reset_buffer()
				end,
				desc = "Reset Buffer",
			},
			{
				"<leader>gs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Stage Hunk",
			},
			{
				"<leader>gu",
				function()
					require("gitsigns").undo_stage_hunk()
				end,
				desc = "Undo Stage Hunk",
			},
			{
				"<leader>go",
				require("telescope.builtin").git_status,
				desc = "Open changed file",
			},
			{
				"<leader>gb",
				require("telescope.builtin").git_branches,
				desc = "Checkout branch",
			},
			{
				"<leader>gc",
				require("telescope.builtin").git_commits,
				desc = "Checkout commit",
			},
			{
				"<leader>gC",
				require("telescope.builtin").git_bcommits,
				desc = "Checkout commit(for current file)",
			},
			{
				"<leader>gd",
				function()
					vim.cmd("Gitsigns diffthis HEAD")
				end,
				desc = "Git Diff HEAD",
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	},
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
}
