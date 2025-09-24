local Path = require("plenary.path")

-- Get the OS-specific vault path
local function get_vault_paths()
	-- Explicitly declare local variables
	local obsidian_vault_personal
	local obsidian_vault_work

	local os_name = vim.loop.os_uname().sysname
	if os_name == "Windows_NT" then
		obsidian_vault_personal = Path:new(vim.env.USERPROFILE, "azin_notes"):absolute()
		obsidian_vault_work = Path:new(vim.env.USERPROFILE, "OneDrive - Wood Rodgers Inc", "5 - azin_obsidian_work")
			:absolute()
	else
		obsidian_vault_personal = Path:new(vim.fn.expand("~"), "azin_notes"):absolute()
		obsidian_vault_work = Path:new(vim.fn.expand("~"), "OneDrive - Wood Rodgers Inc/5 - azin_obsidian_work")
			:absolute()
	end

	return {
		personal_notes = obsidian_vault_personal,
		work_notes = obsidian_vault_work,
	}
end

-- Function to perform Git Push to Obsidian repo
local function git_push_obsidian()
	local current_time = os.date("%Y-%m-%d %H:%M:%S")
	local vault_paths = get_vault_paths()

	for name, vault_path in pairs(vault_paths) do
		-- if not vault_path then
		-- 	print("Vault path is invalid!")
		-- 	return
		-- end

		local git_command = "cd "
			.. vault_path
			.. " && git add . && git commit -m '"
			.. name
			.. " vault backup from Neovim: "
			.. current_time
			.. "' && git push"
		vim.fn.system(git_command)
		print("Obsidian Vault synced with Git!")
	end
end

-- Function to perform Git Pull for all Obsidian vaults
local function git_pull_obsidian()
	local vault_paths = get_vault_paths()

	for name, vault_path in pairs(vault_paths) do
		local pull_output = vim.fn.system("cd " .. vault_path .. " && git pull")
		print("Git Pull Output for " .. name .. ": " .. pull_output)

		-- Reload the current buffer if it's inside any vault
		local current_file = vim.fn.expand("%:p")
		if vim.startswith(current_file, vault_path) then
			vim.cmd("edit!") -- Force reload the buffer
			print("Buffer reloaded with latest changes for " .. name .. ".")
		end
	end

	print("All Obsidian Vaults successfully pulled from Git!")
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
	"obsidian-nvim/obsidian.nvim",
	enabled = true,
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

			workspaces = {
				{ name = "personal_notes", path = get_vault_paths().personal_notes },
				{ name = "work_notes", path = get_vault_paths().work_notes },
			},

			-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
			completion = {
				-- Set to false to disable completion.
				nvim_cmp = true,
				-- Trigger completion
				min_chars = 1,
			},

			daily_notes = {
				folder = "5 - Daily Notes/" .. os.date("%Y") .. "/" .. os.date("%m-%B"),
				date_format = "%Y-%m-%d-%A",
				default_tags = { "daily-notes" },
				template = "template_daily_note.md",
			},

			templates = {
				folder = "3 - References/obsidian_templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
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

			checkbox = {
				enabled = true,
				create_new = true,
				order = { " ", "x", "~", "!", ">" },
			},
		})
	end,

	keys = {
		{ "<leader>oa", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian App" },
		{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian New" },
		{ "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian Quick Switch" },
		{ "<leader>o#", "<cmd>Obsidian tags<cr>", desc = "Obsidian Tags" },
		{ "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian Today" },
		{ "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Obsidian Yesterday" },
		{ "<leader>ow", "<cmd>Obsidian search<cr>", desc = "Obsidian Search Word" },
		{ "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Obsidian Workspace" },
		{ "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle Checkbox" },
		{ "<leader>op", "<cmd>GitPullObsidian<cr>", desc = "Obsidian Git Pull" },
		{ "<leader>oP", "<cmd>GitPushObsidian<cr>", desc = "Obsidian Git Push" },
	},
}
