vim.cmd("autocmd BufNewFile,BufRead *.pyt setfiletype python")

-- chezmoi templates: detect filetype from the extension before .tmpl
vim.filetype.add({
	pattern = {
		[".*%.kdl%.tmpl"] = "kdl",
		[".*%.conf%.tmpl"] = "conf",
		[".*%.toml%.tmpl"] = "toml",
		[".*%.yaml%.tmpl"] = "yaml",
		[".*%.yml%.tmpl"] = "yaml",
		[".*%.json%.tmpl"] = "json",
		[".*%.lua%.tmpl"] = "lua",
		[".*%.sh%.tmpl"] = "sh",
	},
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*/.gdb/*" },
	callback = function()
		vim.opt.eventignore:append({ "BufWritePost", "BufEnter" }) -- Ignore specific events in `.gdb` folders
	end,
})
