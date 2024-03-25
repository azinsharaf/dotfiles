local keymap = vim.keymap.set
local opt = {
	noremap = true,
	silent = true,
}

-- general
keymap("n", "<leader>w", ":w<CR>", { desc = "Write" })
keymap("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>confirm qall<cr>", { desc = "Quit All" })
keymap("n", "<leader>n", "<cmd>enew<cr>", { desc = "New File" })

-- keep the cursor in center (needs to be tested)
keymap("n", "<C-d>", "<C-d>zz", opt)
keymap("n", "<C-u>", "<C-u>zz", opt)
keymap("n", "n", "nzzzv", opt)
keymap("n", "N", "Nzzzv", opt)

-- move highlighted rows
keymap("v", "J", ":m '>+1<cr>gv=gv")
keymap("v", "K", ":m '<-2<cr>gv=gv")

-- quick replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Quick Replace" })

-- which key keymaps
local wk = require("which-key")
local builtin = require("telescope.builtin")

wk.register({
	f = {
		name = "file",
		f = {
			function()
				builtin.find_files()
			end,
			"find files",
		},
		w = {
			function()
				builtin.live_grep()
			end,
			"live grep",
		},
		o = {
			function()
				builtin.oldfiles()
			end,
			"find old files",
		},
		g = {
			function()
				builtin.git_files()
			end,
			"find git files",
		},
		t = {
			function()
				builtin.colorscheme()
			end,
			"find themes",
		},
		r = {
			function()
				builtin.registers()
			end,
			"find registers",
		},
		s = {
			function()
				builtin.spell_suggest()
			end,
			"find spell",
		},
		k = {
			function()
				builtin.keymaps()
			end,
			"find keymaps",
		},
		b = { ":Telescope file_browser find_command=rg,--ignore,--hidden,--files<cr>", "file browser" },
	},
}, { prefix = "<leader>" })
