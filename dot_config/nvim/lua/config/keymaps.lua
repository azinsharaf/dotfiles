local keymap = vim.keymap.set
local opt = {
	noremap = true,
	silent = true,
}

-- parent key maps
require("which-key").register({
	["<leader>"] = { -- Define a parent group for leader key mappings
		name = "My Custom Keymaps", -- Give the parent group a name
		-- Define key mappings within the parent group
		["f"] = { -- Create a sub-group within the parent group
			name = "Find Operations", -- Give the sub-group a name
		},
	},
})

-- general
keymap("n", "<leader>w", ":w<CR>", { desc = "Write" })
keymap("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>confirm qall<cr>", { desc = "Quit All" })
keymap("n", "<leader>n", "<cmd>enew<cr>", { desc = "New File" })

keymap("n", "J", "mzJ`z", opt)
keymap("n", "N", "Nzzzv", opt)

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

-- telescope
local builtin = require("telescope.builtin")
keymap("n", "<leader>ff", function()
	builtin.find_files()
end, { desc = "Find Files" })
keymap("n", "<leader>fw", function()
	builtin.live_grep()
end, { desc = "Live Grep" })
-- keymap('n', '<leader>fw', function() builtin.live_grep() end,{ desc = "Find Files}"})
keymap("n", "<leader>fh", function()
	builtin.help_tags()
end, { desc = "Find Tags" })
keymap("n", "<leader>fo", function()
	builtin.oldfiles()
end, { desc = "Find Old Files" })
keymap("n", "<leader>fg", function()
	builtin.git_files()
end, { desc = "Find Git Files" })
keymap("n", "<leader>ft", function()
	builtin.colorscheme()
end, { desc = "Find Theme" })
keymap("n", "<leader>fr", function()
	builtin.registers()
end, { desc = "Find Registers" })
keymap("n", "<leader>fs", function()
	builtin.spell_suggest()
end, { desc = "Find Spell" })
keymap("n", "<leader>fk", function()
	builtin.keymaps()
end, { desc = "Find Keymaps" })

-- telescope file browser
keymap(
	"n",
	"<leader>fb",
	":Telescope file_browser find_command=rg,--ignore,--hidden,--files<cr>",
	{ desc = "File Browser" }
)
