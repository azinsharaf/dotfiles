return {
	"xiyaowong/transparent.nvim",
	enabled = true,
	lazy = false,

	config = function()
		-- Safelist: groups that MUST keep their background
		local safelist = {
			CursorLine = true,
			BlinkCmpDocCursorLine = true,
			CursorColumn = true,
			Visual = true,
			VisualNOS = true,
			Search = true,
			IncSearch = true,
			CurSearch = true,
			Substitute = true,
			MatchParen = true,
			DiffAdd = true,
			DiffChange = true,
			DiffDelete = true,
			DiffText = true,
			PmenuSel = true,
			PmenuThumb = true,
			WildMenu = true,
			SpellBad = true,
			SpellCap = true,
			SpellRare = true,
			SpellLocal = true,
			DiagnosticError = true,
			DiagnosticWarn = true,
			DiagnosticInfo = true,
			DiagnosticHint = true,
			DiagnosticUnderlineError = true,
			DiagnosticUnderlineWarn = true,
			DiagnosticUnderlineInfo = true,
			DiagnosticUnderlineHint = true,
			LspReferenceText = true,
			LspReferenceRead = true,
			LspReferenceWrite = true,
			IlluminatedWordText = true,
			IlluminatedWordRead = true,
			IlluminatedWordWrite = true,
			SnippetTabstop = true,
			TabLineSel = true,
		}

		-- Aggressively strip background from every highlight group
		local function strip_all_bg()
			for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
				if not safelist[group] then
					local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
					if ok and hl and hl.bg then
						hl.bg = "NONE"
						hl.ctermbg = "NONE"
						pcall(vim.api.nvim_set_hl, 0, group, hl)
					end
				end
			end
		end

		require("transparent").setup({
			groups = {
				"Normal",
				"NormalNC",
				"Comment",
				"Constant",
				"Special",
				"Identifier",
				"Statement",
				"PreProc",
				"Type",
				"Underlined",
				"Todo",
				"String",
				"Function",
				"Conditional",
				"Repeat",
				"Operator",
				"Structure",
				"LineNr",
				"NonText",
				"SignColumn",
				"CursorLine",
				"CursorLineNr",
				"StatusLine",
				"StatusLineNC",
				"EndOfBuffer",
			},
			extra_groups = {
				"NormalFloat",
				"NvimTreeNormal",
				"FloatBorder",
				"TelescopeNormal",
				"TelescopePromptNormal",
				"TelescopeResultsNormal",
				"TelescopePreviewNormal",
				"TelescopeBorder",
				"TelescopePromptBorder",
				"TelescopeResultsBorder",
				"TelescopePreviewBorder",
				"MasonNormal",
				"MasonBorder",
				"LazyNormal",
				"LazyFloat",
				"LazyFloatBorder",
				"WhichKeyFloat",
				"WhichKeyBorder",
				"NotifyBackground",
				"TroubleNormal",
				"TroubleNormalNC",
				"Pmenu",
				"PmenuSel",
				"WinBar",
				"WinBarNC",
			},
			exclude_groups = {},
			-- After transparent.nvim clears its configured groups, nuke everything else
			on_clear = strip_all_bg,
		})

		local function clear()
			require("transparent").clear()
		end

		-- transparent.nvim defaults to OFF unless its cache file exists; force it on,
		-- otherwise clear() is a no-op and nothing below takes effect.
		vim.g.transparent_enabled = true
		clear()

		-- Re-clear when the colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = clear,
		})

		-- Re-clear after Lazy finishes loading startup plugins
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyDone",
			once = true,
			callback = clear,
		})

		-- Re-clear when any plugin window opens (Telescope, Mason, Lazy, NvimTree, etc.)
		-- Defer slightly so the plugin has time to define its highlights first.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				vim.defer_fn(clear, 50)
			end,
		})
	end,
}
