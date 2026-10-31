return {
	"mvllow/modes.nvim",
	tag = "v0.2.0",
	config = function()
		require("modes").setup({
			colors = {
				bg = "", -- Optional bg param, defaults to Normal hl group
				copy = "#f5c359",
				delete = "#c75c6a",
				insert = "#78ccc5",
				visual = "#3d59a1", -- blue selection, matches Visual in colorscheme.lua
			},

			-- Set opacity for cursorline and number background
			line_opacity = 0.15,

			-- Enable cursor highlights
			set_cursor = true,

			-- Enable cursorline initially, and disable cursorline for inactive windows
			-- or ignored filetypes
			set_cursorline = true,

			-- Enable line number highlights to match cursorline
			set_number = true,

			-- Disable modes highlights in specified filetypes
			-- Please PR commonly ignored filetypes
			ignore_filetypes = { "NvimTree", "TelescopePrompt" },
		})

		-- modes.nvim blends its visual colour with Normal's bg. Normal is transparent, so the
		-- blend comes out empty and the selection disappears. Set the group directly each
		-- time visual mode starts, after modes.nvim has recalculated it.
		vim.api.nvim_create_autocmd("ModeChanged", {
			pattern = "*:[vV\22]",
			callback = function()
				vim.schedule(function()
					vim.api.nvim_set_hl(0, "ModesVisualVisual", { bg = "#3d59a1" })
				end)
			end,
		})
	end,
}
