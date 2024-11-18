local Path = require("plenary.path")

-- define workspaces
local workspacePaths = {
    {
        name = "work",
        path = Path:new(os.getenv("USERPROFILE") .. "/OneDrive - Wood Rodgers Inc/Obsidian/Obsidian_work"):expand(),
    },
    {
        name = "personal",
        path = Path:new(os.getenv("USERPROFILE") .. "/azin_obsidian_personal"):expand(),
    },
}

local workspaces = {}

for _, workspaceInfo in ipairs(workspacePaths) do
    local workspacePath = workspaceInfo.path
    if Path:new(workspacePath):exists() then
        local workspace = {
            name = workspaceInfo.name,
            path = workspacePath,
        }
        table.insert(workspaces, workspace)
    end
end

-- Combine to form the folder path dynamically
local year = os.date("%Y")
local month_name = os.date("%m-%B") -- e.g., "11-November"-
local daily_notes_folder = "daily_notes/" .. year .. "/" .. month_name

return {
    "epwalsh/obsidian.nvim",
    enabled = true,
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",

        -- see below for full list of optional dependencies 👇
    },

    config = function()
        require("obsidian").setup({
            workspaces = workspaces,

            -- see below for full list of options 👇
            daily_notes = {
                -- Optional, if you keep daily notes in a separate directory.
                folder = daily_notes_folder,
                -- Optional, if you want to change the date format for the ID of daily notes.
                date_format = "%Y-%m-%d-%A",
                -- Optional, if you want to change the date format of the default alias of daily notes.
                -- alias_format = "%B %-d, %Y",
                -- Optional, default tags to add to each new daily note created.
                default_tags = { "daily-notes" },
                -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
                template = "template_daily_note.md"
            },
            -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
            completion = {
                -- Set to false to disable completion.
                nvim_cmp = true,
                -- Trigger completion at 2 chars.
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
        })
    end,

    keys = {
        { "<leader>oa", "<cmd>ObsidianOpen<cr>",        desc = "Open in Obsidian App" },
        { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "Obsidian New" },
        { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian Quick Switch" },
        { "<leader>ol", "<cmd>ObsidianFollowLink<cr>",  desc = "Obsidian Folow Link" },
        { "<leader>og", "<cmd>ObsidianTags<cr>",        desc = "Obsidian Tags" },
        { "<leader>ot", "<cmd>ObsidianToday<cr>",       desc = "Obsidian Today" },
        { "<leader>of", "<cmd>ObsidianSearch<cr>",      desc = "Obsidian Search Word" },
        { "<leader>ow", "<cmd>ObsidianWorkspace<cr>",   desc = "Obsidian Workspace" },
    },
}
