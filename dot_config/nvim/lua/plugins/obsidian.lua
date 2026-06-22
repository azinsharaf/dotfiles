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
	event = "VeryLazy",
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
			link = {
				style = "wiki",
				format = "shortest",
				auto_update = false,
			},

			log_level = vim.log.levels.INFO,
			note_id_func = require("obsidian.builtin").zettel_id,
			-- wiki_link_func = require("obsidian.builtin").wiki_link_id_prefix,
			-- markdown_link_func = require("obsidian.builtin").markdown_link,
			open_notes_in = "current",
			legacy_commands = false,

			---@class obsidian.config.FrontmatterOpts
			---
			--- Whether to enable frontmatter, boolean for global on/off, or a function that takes filename and returns boolean.
			---@field enabled? (fun(fname: string?): boolean)|boolean
			---
			--- Function to turn Note attributes into frontmatter.
			---@field func? fun(note: obsidian.Note): table<string, any>
			--- Function that is passed to table.sort to sort the properties, or a fixed order of properties.
			---
			--- List of string that sorts frontmatter properties, or a function that compares two values, set to vim.NIL/false to do no sorting
			---@field sort? string[] | (fun(a: any, b: any): boolean) | vim.NIL | boolean
			frontmatter = {
				enabled = true,
				func = require("obsidian.builtin").frontmatter,
				sort = { "id", "aliases", "tags" },
			},

			daily_notes = {
				folder = "5 - Daily Notes/" .. os.date("%Y") .. "/" .. os.date("%m-%B"),
				date_format = "%Y-%m-%d-%A",
				default_tags = { "daily-notes" },
				template = "template_daily_note.md",
				workdays_only = false,
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
			search = {
				sort_by = "modified",
				sort_reversed = true,
				max_lines = 1000,
			},

			---@class obsidian.config.AttachmentsOpts
			---
			---Default folder to save images to, relative to the vault root (/) or current dir (.), see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images#change-image-save-location
			---@field img_folder? string
			---
			---Default name for pasted images
			---@field img_name_func? fun(): string
			---
			---Default text to insert for pasted images
			---@field img_text_func? fun(path: obsidian.Path): string
			---
			---Whether to confirm the paste or not. Defaults to true.
			---@field confirm_img_paste? boolean
			attachments = {
				folder = "3 - References/attachments",
				img_text_func = require("obsidian.builtin").img_text_func,
				img_name_func = function()
					return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
				end,
				confirm_img_paste = true,
			},

			---@class obsidian.config.FooterOpts
			---
			---@field enabled? boolean
			---@field format? string
			---@field hl_group? string
			---@field separator? string|false Set false to disable separator; set an empty string to insert a blank line separator.
			footer = {
				enabled = true,
				format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
				hl_group = "Comment",
				separator = string.rep("-", 80),
			},

		---@class obsidian.config.CheckboxOpts
		---
		---@field enabled? boolean
		---
		---Order of checkbox state chars, e.g. { " ", "x" }
		---@field order? string[]
		---
		---Whether to create new checkbox on paragraphs
		---@field create_new? boolean
		checkbox = {
			enabled = false,
			create_new = true,
			order = { " ", "x", "~", "!", ">" },
		},

			---@class obsidian.config.CommentOpts
			---@field enabled boolean
			comment = {
				enabled = false,
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
		{ "<leader>oW", "<cmd>Obsidian workspace<cr>", desc = "Obsidian Workspace" },
		{ "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle Checkbox" },
		{ "<leader>op", "<cmd>GitPullObsidian<cr>", desc = "Obsidian Git Pull" },
		{ "<leader>oP", "<cmd>GitPushObsidian<cr>", desc = "Obsidian Git Push" },
	},
}
