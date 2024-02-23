return {
	"xvzc/chezmoi.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("chezmoi").setup({
			-- your configurations
			edit = {
				watch = true, -- Set true to automatically apply on save.
				force = true, -- Set true to force apply. Works only when watch = true.
			},
			notification = {
				on_open = true, -- vim.notify when start editing chezmoi-managed file.
				on_apply = true, -- vim.notify on apply.
			},
			telescope = {
				select = { "<CR>" },
			},
		})
	end,
}
