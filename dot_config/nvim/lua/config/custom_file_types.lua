vim.cmd("autocmd BufNewFile,BufRead *.pyt setfiletype python")

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*/.gdb/*" },
	callback = function()
		vim.opt.eventignore:append({ "BufWritePost", "BufEnter" }) -- Ignore specific events in `.gdb` folders
	end,
})
