-- Set filetype explicitly for *.pyt
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
		[".*%.py%.tmpl"] = "python",
	},
})

-- Ignore specific events in `.gdb` folders
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*/.gdb/*" },
	callback = function()
		-- Ignore specific events in `.gdb` folders
		vim.opt.eventignore:append({ "BufWritePost", "BufEnter" })
	end,
})

-- make `gcc` work on JSON by defining a commentstring
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
		-- allows line comments like: // comment
		vim.bo.commentstring = "// %s"
	end,
})

-- Strip stray carriage returns from Python files (incl. .pyt) before write.
-- Safety net for opencode.nvim / formatters that may inject ^M and pollute
-- git diffs. The repo's .gitattributes pins these files to LF, so any \r
-- that lands here is a leak we want gone before the bytes hit disk.
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.py", "*.pyt" },
	callback = function()
		vim.cmd("keeppatterns %s/\\r//ge")
	end,
})
