return {
	"f-person/git-blame.nvim",
	-- Load the plugin lazily
	event = "VeryLazy",
	enabled = true,

	config = function()
		-- Plugin options
		require("gitblame").setup({
			enabled = false, -- Enable the plugin
			message_template = " <summary> • <date> • <author> • <<sha>>", -- Custom blame message format
			date_format = "%m-%d-%Y %H:%M:%S", -- Date format for blame messages
			virtual_text_column = 1, -- Starting column for virtual text
		})

		-- Define keybindings for the plugin
		vim.keymap.set("n", "<leader>go", ":GitBlameOpenFileURL<CR>", { desc = "Open file in browser" })
		vim.keymap.set("n", "<leader>tb", ":GitBlameToggle<CR>", { desc = "Toggle Git blame" })

		-- Adjust shell settings based on the OS
		if vim.loop.os_uname().sysname == "Windows_NT" then
			-- Ensure Neovim uses PowerShell on Windows
			vim.o.shell = "pwsh"
			vim.o.shellcmdflag = "-NoProfile -Command"
		else
			-- Use a standard shell on Unix-like systems
			vim.o.shell = "/bin/zsh"
		end
	end,
}
