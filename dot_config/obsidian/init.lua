vim.g.mapleader = " "

vim.opt.scrolloff = 8
vim.opt.textobjects = true
vim.opt.clipboard = "unnamed"
vim.opt.whichkeygrouping = "grouped"
vim.opt.whichkey = "all"

-- delete table entries to use termianl instead
vim.keymap.del("n", "t")

-- which-key
local wk = vim.obsidian.whichkey
wk.add({
	{ "<leader>f", group = "File" },
	{ "<leader>g", group = "Git" },
	{ "<leader>a", group = "AI" },
	{ "<leader>e", group = "Explorer" },
	{ "<leader>o", group = "Obsidian" },
	{ "<leader>t", group = "Terminal" },
})

---- commands

-- file
vim.keymap.set("n", "<leader>ff", function()
	vim.cmd("ob switcher:open")
end, { desc = "Open Recent Files" })

vim.keymap.set("n", "<leader>fw", function()
	vim.cmd("ob global-search:open")
end, { desc = "Find Word" })

vim.keymap.set("n", "<leader>fn", function()
	vim.cmd("ob file-explorer:new-file")
end, { desc = "New File" })

-- git
vim.keymap.set("n", "<leader>gp", function()
	vim.cmd("ob obsidian-git:pull")
end, { desc = "Git Pull" })

vim.keymap.set("n", "<leader>gP", function()
	vim.cmd("ob obsidian-git:push")
end, { desc = "Git Push" })

-- AI
vim.keymap.set("n", "<leader>aa", function()
	vim.cmd("ob agent-client:open-chat-view")
end, { desc = "Open AI Chat" })

vim.keymap.set("n", "<leader>ee", function()
	vim.cmd("ob app:toggle-left-sidebar")
end, { desc = "Toggle Left Bar" })

-- explorer
vim.keymap.set("n", "<leader>er", function()
	vim.cmd("ob app:toggle-right-sidebar")
end, { desc = "Toggle Right Bar" })

-- obsidian
vim.keymap.set("n", "<leader>ot", function()
	vim.cmd("ob daily-notes")
end, { desc = "Today daily note" })

vim.keymap.set("n", "<leader>on", function()
	vim.cmd("ob daily-notes:goto-next")
end, { desc = "Next daily note" })

vim.keymap.set("n", "<leader>op", function()
	vim.cmd("ob daily-notes:goto-prev")
end, { desc = "Prev daily note" })

-- terminal
vim.keymap.set("n", "<leader>tt", function()
	vim.cmd("ob terminal:open-terminal.default.current")
end, { desc = "Open Terminal" })
