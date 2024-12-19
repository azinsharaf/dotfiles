return {
	"gelguy/wilder.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for fzy-lua-native
		"romgrk/fzy-lua-native", -- Required for fzy-based fuzzy matching
	},
	config = function()
		local wilder = require("wilder")

		wilder.setup({
			modes = { ":", "/", "?" }, -- Command-line modes
			use_python_remote_plugin = 0, -- Disable Python remote plugin
		})

		local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
			winblend = 20, -- Transparency
			border = "rounded", -- Popup menu border style
			empty_message = wilder.popupmenu_empty_message_with_spinner(),
			highlighter = wilder.lua_fzy_highlighter(),
			left = {
				" ",
				wilder.popupmenu_devicons(),
				wilder.popupmenu_buffer_flags({
					flags = " A + ",
					icons = { ["+"] = "modified", a = "active", h = "hidden", ["%"] = "current", ["#"] = "alternate" },
				}),
			},
			right = {
				" ",
				wilder.popupmenu_scrollbar(),
			},
		}))

		local wildmenu_renderer = wilder.wildmenu_renderer({
			highlighter = wilder.lua_fzy_highlighter(),
			separator = " ¬∑ ",
			left = { " ", wilder.wildmenu_spinner(), " " },
			right = { " ", wilder.wildmenu_index() },
		})

		wilder.set_option(
			"renderer",
			wilder.renderer_mux({
				[":"] = popupmenu_renderer,
				["/"] = popupmenu_renderer,
				["?"] = popupmenu_renderer,
				substitute = wildmenu_renderer,
			})
		)

		wilder.set_option("pipeline", {
			wilder.branch(
				wilder.cmdline_pipeline({
					fuzzy = 2,
					fuzzy_filter = wilder.lua_fzy_filter(),
				}),
				wilder.vim_search_pipeline()
			),
		})
	end,
}
