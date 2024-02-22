-- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
return {
	"numToStr/Comment.nvim",
	opts = {
		-- add any options here
	},
	lazy = false,
	config = function()
		local Comment = require("Comment")

		Comment.setup({
			vim.cmd([[autocmd FileType json setlocal commentstring=//\ %s]]),
		})
	end,
}
