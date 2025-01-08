local Path = require("plenary.path")

-- Get the OS-specific vault path
local function get_vault_path()
	local os_name = vim.loop.os_uname().sysname
	if os_name == "Windows_NT" then
		local obsidian_vault = Path:new(vim.env.USERPROFILE, "azin_notes"):absolute()
		return obsidian_vault
	else
		local obsidian_vault = Path:new(vim.fn.expand("~"), "azin_notes"):absolute()
		return obsidian_vault
	end
end

-- Function to perform Git Push to Obsidian repo
local function git_push_obsidian()
	local current_time = os.date("%Y-%m-%d %H:%M:%S")
	local vault_path = get_vault_path()
	if not vault_path then
		print("Vault path is invalid!")
		return
	end

	local git_command = "cd "
		.. vault_path
		.. " && git add . && git commit -m 'vault backup from Neovim: "
		.. current_time
		.. "' && git push"
	vim.fn.system(git_command)
	print("Obsidian Vault synced with Git!")
end

-- Function to perform Git Pull for Obsidian Vault
local function git_pull_obsidian()
	local vault_path = get_vault_path()
	if not vault_path then
		print("Vault path is invalid!")
		return
	end

	-- Pull updates from the Git repository
	local pull_output = vim.fn.system("cd " .. vault_path .. " && git pull")
	print("Git Pull Output: " .. pull_output)

	-- Reload the current buffer if it is part of the vault
	local current_file = vim.fn.expand("%:p")
	if vim.startswith(current_file, vault_path) then
		vim.cmd("edit!") -- Force reload the buffer
		print("Buffer reloaded with latest changes.")
	end

	print("Obsidian Vault successfully pulled from Git!")
end

-- Command to Git pull manually
vim.api.nvim_create_user_command("GitPullObsidian", git_pull_obsidian, {})

-- Command to Git push manually
vim.api.nvim_create_user_command("GitPushObsidian", git_push_obsidian, {})

-- Autocmd to trigger Git pull when opening Markdown files in the vault
-- vim.api.nvim_create_autocmd("BufReadPre", {
-- 	pattern = get_vault_path() .. "/*.md", -- Match Markdown files in the vault
-- 	callback = function()
-- 		git_pull_obsidian()
-- 	end,
-- })

-- Autocmd to trigger Git push when writing Markdown files in the vault
-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	pattern = "*.md",
-- 	callback = function()
-- 		git_push_obsidian()
-- 		print("Vault synced with Git!")
-- 	end,
-- })

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
		-- Configure obsidian.nvim with the valid workspace
		require("obsidian").setup({

			workspaces = { { name = "azin_notes", path = get_vault_path() } },

			-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
			completion = {
				-- Set to false to disable completion.
				nvim_cmp = true,
				-- Trigger completion
				min_chars = 1,
			},

			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "daily_notes",
				-- Optional, if you want to change the date format for the ID of daily notes.
				date_format = "%Y-%m-%d-%A",
				-- Optional, if you want to change the date format of the default alias of daily notes.
				-- alias_format = "%B %-d, %Y",
				-- Optional, default tags to add to each new daily note created.
				default_tags = { "daily-notes" },
				-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
				template = "template_daily_note.md",
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
				enable = false, -- set to false to disable all additional syntax features
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
		{ "<leader>op", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian Templates" },
		{ "<leader>os", "<cmd>GitSync<cr>", desc = "Obsidian push with Github" },
	},
}
