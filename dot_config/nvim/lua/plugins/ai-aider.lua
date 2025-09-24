return {
	"joshuavial/aider.nvim",
	enabled = true,
	event = "VeryLazy",
	config = function()
		require("aider").setup({
			-- your configuration comes here
			-- if you don't want to use the default settings
			auto_manage_context = true, -- automatically manage buffer context
			default_bindings = true, -- use default <leader>A keybindings
			debug = false, -- enable debug logging
			vim = true,
			ignore_buffers = {},
		})
	end,
}
