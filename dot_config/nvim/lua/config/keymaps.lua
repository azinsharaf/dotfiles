local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local telescope = require("telescope")
telescope.load_extension("chezmoi")

-- general
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
-- keymap("n", "<leader>nh", ":noh<CR>", { desc = "No Highlight" })
-- keymap("n", "<leader>w", ":w<CR>", { desc = "Write" })
-- keymap("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
-- keymap("n", "<leader>Q", "<cmd>confirm qall<cr>", { desc = "Quit All" })
-- keymap("n", "<leader>n", "<cmd>enew<cr>", { desc = "New File" })

-- window management
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- keep the cursor in center (needs to be tested)
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts) -- move highlighted rows

keymap("v", "J", ":m '>+1<cr>gv=gv")
keymap("v", "K", ":m '<-2<cr>gv=gv")

keymap("n", "<RightMouse>", "<cmd>:popup PopUp<CR>")
local wk = require("which-key")

wk.register({

	-- file related
	-- f = {
	-- 	name = "File",
	-- 	f = { "<cmd>Telescope find_files<cr>", "Find Files" },
	-- 	c = { telescope.extensions.chezmoi.find_files, "Find chezmoi files" },
	-- 	g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
	-- 	b = { "<cmd>Telescope buffers<cr>", "Buffers" },
	-- 	h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
	-- 	o = { "<cmd>Telescope oldfiles<cr>", "Old Files" },
	-- 	r = { "<cmd>Telescope registers<cr>", "Registers" },
	-- 	s = { "<cmd>Telescope spell_suggest<cr>", "Spell Suggestions" },
	-- 	k = { "<cmd>Telescope keymaps<cr>", "Key Maps" },
	-- 	x = { "<cmd>Telescope file_browser hidden=true<cr>", "File Browser" },
	-- },

	-- git related using telescope
	g = {
		name = "Git",
		s = { "<cmd>Telescope git_status<cr>", "Git Status" },
		c = { "<cmd>Telescope git_commits<cr>", "Git Commits" },
		b = { "<cmd>Telescope git_branches<cr>", "Git Branches" },
		f = { "<cmd>Telescope git_files<cr>", "Git Files" },
	},

	-- package manager and mason related
	p = {
		name = "Package",
		p = { "<cmd>Lazy<cr>", "Lazy Package Manager" },
		m = { "<cmd>Mason<cr>", "Mason" },
	},

	-- toggles
	t = {
		name = "Toggle",
		k = { "<cmd>Screenkey<cr>", "Screenkey" },
	},

	c = { "<Plug>(comment_toggle_linewise_current)", "Comment" },
}, { prefix = "<leader>" })
