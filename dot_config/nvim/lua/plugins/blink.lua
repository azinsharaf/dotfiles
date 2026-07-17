return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"echasnovski/mini.snippets",
		"rafamadriz/friendly-snippets",
	},
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "default" },
		appearance = {
			nerd_font_variant = "mono",
		},
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			frecency = { enabled = true },
			use_proximity = true,
		},
		snippets = { preset = "mini_snippets" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				cmdline = {
					min_keyword_length = function(ctx)
						if ctx.mode == "cmdline" and not ctx.line:find(" ") then
							return 1
						end
						return 0
					end,
				},
			},
		},
		-- Cmdline completion is case-insensitive in two ways:
		--  1. vim.o.wildignorecase = true in options.lua makes the cmdline
		--     source (which calls getcompletion()) match commands case-insensitively.
		--  2. blink.cmp's Rust fuzzy matcher is case-insensitive by default.
		completion = {
			menu = {
				border = "rounded",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = { border = "rounded", max_height = 30, max_width = 60 },
			},
			trigger = { show_on_keyword = true, show_on_trigger_character = true },
			ghost_text = { enabled = true },
			list = { selection = { preselect = true, auto_insert = true } },
		},
		signature = {
			enabled = true,
			window = { border = "rounded" },
			trigger = { show_on_insert = true, show_on_trigger_character = true },
		},
		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			sources = { "cmdline", "buffer" },
			completion = {
				-- auto_show = true makes the fuzzy popup appear immediately on every
				-- keystroke, no Tab required. The popup shows above the cmdline.
				menu = { auto_show = true },
				ghost_text = { enabled = true },
			},
		},
	},
	config = function(_, opts)
		require("blink.cmp").setup(opts)

		local function hl_fg(group, fallback)
			local ok, val = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
			if ok and val and val.fg then
				return string.format("#%06x", val.fg)
			end
			return fallback
		end

		local function hl_link(group, target)
			vim.api.nvim_set_hl(0, group, { link = target })
		end

		local function hl(group, spec)
			vim.api.nvim_set_hl(0, group, spec)
		end

		hl_link("BlinkCmpMenuBorder", "FloatBorder")
		hl_link("BlinkCmpDocBorder", "FloatBorder")
		hl_link("BlinkCmpSignatureHelpBorder", "FloatBorder")
		hl_link("BlinkCmpMenuSelection", "CursorLine")
		hl_link("BlinkCmpScrollBarThumb", "PmenuThumb")
		hl_link("BlinkCmpScrollBarGutter", "PmenuSbar")

		hl("BlinkCmpLabelMatch", { fg = hl_fg("Cursor") or hl_fg("Search") or hl_fg("IncSearch"), bold = true })
		hl("BlinkCmpGhostText", { fg = hl_fg("Comment"), italic = true })
		hl("BlinkCmpSource", { fg = hl_fg("Comment") })
		hl("BlinkCmpLabelDescription", { fg = hl_fg("Comment"), italic = true })
		hl("BlinkCmpLabelDetail", { fg = hl_fg("Comment") })
		hl("BlinkCmpSignatureHelpActiveParameter", { fg = hl_fg("Title") or hl_fg("Function"), bold = true })

		local kind_color = {
			Function = hl_fg("Function"),
			Method = hl_fg("Function"),
			Constructor = hl_fg("Function"),
			Class = hl_fg("Type"),
			Interface = hl_fg("Type"),
			Struct = hl_fg("Type"),
			TypeParameter = hl_fg("Type"),

			Enum = hl_fg("Constant"),
			EnumMember = hl_fg("Constant"),
			Constant = hl_fg("Constant"),
			Unit = hl_fg("Constant"),
			Value = hl_fg("Constant"),
			Number = hl_fg("Constant"),
			Color = hl_fg("Constant"),

			String = hl_fg("String"),
			Keyword = hl_fg("Keyword"),
			Snippet = hl_fg("Statement") or hl_fg("PreProc"),

			Variable = hl_fg("Identifier"),
			Property = hl_fg("Identifier"),
			Field = hl_fg("Identifier"),
			Reference = hl_fg("Identifier"),

			File = hl_fg("Special"),
			Folder = hl_fg("Special"),
			Operator = hl_fg("Special"),
			Event = hl_fg("Special"),

			Text = hl_fg("Normal"),
			Module = hl_fg("Type"),
			Namespace = hl_fg("Type"),
			Package = hl_fg("Type"),
		}

		for kind, color in pairs(kind_color) do
			if color then
				hl("BlinkCmpKind" .. kind, { fg = color, bold = true })
			end
		end
	end,
}
