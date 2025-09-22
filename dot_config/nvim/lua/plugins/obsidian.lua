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
		-- determine vaults and hostname to pick default workspace
		local vaults = get_vault_paths()
		local hostname = (vim.loop.os_uname().nodename or vim.env.COMPUTERNAME or ""):lower()

		local default_workspace_name = "personal_notes"
		if hostname:match("ws-oak512-007") then
			default_workspace_name = "work_notes"
		end

		local workspaces_map = {
			personal_notes = vaults.personal_notes,
			work_notes = vaults.work_notes,
		}

		-- Configure obsidian.nvim with the valid workspace
		require("obsidian").setup({

			workspaces = workspaces_map,

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

			checkbox = {
				enabled = true,
				create_new = true,
				order = { " ", "x", "~", "!", ">" },
			},
		})

		-- try to set the default workspace (handle different obsidian.nvim API names)
		vim.defer_fn(function()
			local ok, obs = pcall(require, "obsidian")
			if not ok or not obs then
				return
			end

			local success, err = pcall(function()
				if type(obs.set_vault) == "function" then
					obs.set_vault(default_workspace_name)
				elseif type(obs.open_vault) == "function" then
					obs.open_vault(default_workspace_name)
				elseif type(obs.switch) == "function" then
					obs.switch(default_workspace_name)
				elseif type(obs.open) == "function" and workspaces_map[default_workspace_name] then
					obs.open({ dir = workspaces_map[default_workspace_name] })
				else
					error("no known API to set Obsidian workspace")
				end
			end)

			if not success then
				vim.schedule(function()
					vim.notify("Could not set default Obsidian workspace: " .. tostring(err), vim.log.levels.WARN)
				end)
			end
		end, 50)
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
		{ "<leader>ou", "<cmd>GitPullObsidian<cr>", desc = "Obsidian Git Pull" },
		{ "<leader>op", "<cmd>GitPushObsidian<cr>", desc = "Obsidian Git Push" },
	},
}
