local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local telescope = require("telescope")
telescope.load_extension("chezmoi")

-- general
keymap("i", "jk", "<ESC>", { desc = "exit insert mode with jk" })

-- window management
keymap("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" }) -- split window vertically
keymap("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" }) -- split window horizontally
keymap("n", "<leader>se", "<C-w>=", { desc = "make splits equal size" }) -- make split windows equal width & height
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "close current split" }) -- close current split window

keymap("n", "<leader><leader>", "<C-^>", { desc = "Alternate buffer" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "move focus to the lower window" })

-- keep the cursor in center (needs to be tested)
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts) -- move highlighted rows

-- keymap("v", "J", ":m '>+1<cr>gv=gv")
-- keymap("v", "K", ":m '<-2<cr>gv=gv")

keymap("n", "<RightMouse>", "<cmd>:popup PopUp<CR>")

keymap("n", "<leader>ts", ":set spell!<CR>", { desc = "Toggle Spell Check" })
