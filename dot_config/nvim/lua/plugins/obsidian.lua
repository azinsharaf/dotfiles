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

				-- see below for full list of options 👇

				-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
				completion = {
					-- Set to false to disable completion.
					nvim_cmp = true,
					-- Trigger completion
					min_chars = 1,
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
