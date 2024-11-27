local Path = require("plenary.path")

-- Get the OS-specific vault path
local function get_vault_path()
	local os_name = vim.loop.os_uname().sysname
	if os_name == "Windows_NT" then
		return {
			work = Path:new(vim.env.USERPROFILE, "OneDrive - Wood Rodgers Inc", "Obsidian", "Obsidian_work"):absolute(),
			personal = Path:new(vim.env.USERPROFILE, "azin_obsidian_personal"):absolute(),
		}
	else
		return {
			work = Path:new(vim.fn.expand("~"), "OneDrive - Wood Rodgers Inc", "Obsidian", "Obsidian_work"):absolute(),
			personal = Path:new(vim.fn.expand("~"), "azin_obsidian_personal"):absolute(),
		}
	end
end

-- Get resolved paths and define workspaces
local vault_paths = get_vault_path()

-- Ensure workspaces are properly named and unique
local workspaces = {
	{ name = "work", path = vault_paths.work },
	{ name = "personal", path = vault_paths.personal },
}

-- Validate paths and create a table of valid workspaces
local valid_workspaces = {}
for _, ws in ipairs(workspaces) do
	if Path:new(ws.path):exists() then
		table.insert(valid_workspaces, ws)
	end
end

-- Define the plugin with dependencies and keybindings

return {
	"epwalsh/obsidian.nvim",
	enabled = true,
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = false,
	ft = "markdown",
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},

	config = function()
		if #valid_workspaces > 0 then
			-- Configure obsidian.nvim with the valid workspace
			require("obsidian").setup({

				workspaces = valid_workspaces, -- provide all valid workspaces

				-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
				completion = {
					-- Set to false to disable completion.
					nvim_cmp = true,
					-- Trigger completion
					min_chars = 1,
				},
				-- Optional, for templates (see below).
				templates = {
					folder = "templates",
					date_format = "%Y-%m-%d",
					time_format = "%H:%M",
					-- A map for custom variables, the key should be the variable and the value a function
					substitutions = {},
				},
				-- Optional, sort search results by "path", "modified", "accessed", or "created".
				-- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
				-- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
				sort_by = "modified",
				sort_reversed = true,

				-- Optional, configure additional syntax highlighting / extmarks.
				-- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
				ui = {
					enable = true, -- set to false to disable all additional syntax features
					update_debounce = 200, -- update delay after a text change (in milliseconds)
					max_file_length = 5000, -- disable UI features for files with more than this many lines
					-- Define how various check-boxes are displayed
					checkboxes = {
						-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
						[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
						["x"] = { char = "", hl_group = "ObsidianDone" },
						[">"] = { char = "", hl_group = "ObsidianRightArrow" },
						["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
						["!"] = { char = "", hl_group = "ObsidianImportant" },
						-- Replace the above with this if you don't have a patched font:
						-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
						-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

						-- You can also add more custom ones...
					},
					-- Use bullet marks for non-checkbox lists.
					bullets = { char = "•", hl_group = "ObsidianBullet" },
					external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
					-- Replace the above with this if you don't have a patched font:
					-- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
					reference_text = { hl_group = "ObsidianRefText" },
					highlight_text = { hl_group = "ObsidianHighlightText" },
					tags = { hl_group = "ObsidianTag" },
					block_ids = { hl_group = "ObsidianBlockID" },
					hl_groups = {
						-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
						ObsidianTodo = { bold = true, fg = "#f78c6c" },
						ObsidianDone = { bold = true, fg = "#89ddff" },
						ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
						ObsidianTilde = { bold = true, fg = "#ff5370" },
						ObsidianImportant = { bold = true, fg = "#d73128" },
						ObsidianBullet = { bold = true, fg = "#89ddff" },
						ObsidianRefText = { underline = true, fg = "#c792ea" },
						ObsidianExtLinkIcon = { fg = "#c792ea" },
						ObsidianTag = { italic = true, fg = "#89ddff" },
						ObsidianBlockID = { italic = true, fg = "#89ddff" },
						ObsidianHighlightText = { bg = "#75662e" },
					},
				},
			})
		else
			-- Provide a fallback message when no workspace is found
			print("No valid Obsidian workspace found. Obsidian.nvim is not fully configured.")
		end
	end,

	keys = {
		{ "<leader>oa", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian App" },
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian New" },
		{ "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian Quick Switch" },
		{ "<leader>ol", "<cmd>ObsidianFollowLink<cr>", desc = "Obsidian Folow Link" },
		{ "<leader>og", "<cmd>ObsidianTags<cr>", desc = "Obsidian Tags" },
		{ "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Obsidian Today" },
		{ "<leader>of", "<cmd>ObsidianSearch<cr>", desc = "Obsidian Search Word" },
		{ "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Obsidian Workspace" },
	},
}
