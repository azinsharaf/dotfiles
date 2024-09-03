local Path = require("plenary.path")

local workspacePaths = {
    { name = "work",     path = Path:new(os.getenv("USERPROFILE") .. "/OneDrive - Wood Rodgers Inc/Obsidian/Obsidian_work"):expand() },
    { name = "personal", path = Path:new(os.getenv("USERPROFILE") .. "/iCloudDrive/iCloud~md~obsidian/obsidian_personal"):expand() },
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

return {
    "epwalsh/obsidian.nvim",
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

        -- see below for full list of optional dependencies 👇
    },
    opts = {
        workspaces = workspaces,

        -- see below for full list of options 👇
        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = "daily_notes",
            -- Optional, if you want to change the date format for the ID of daily notes.
            date_format = "%Y-%m-%d",
            -- Optional, if you want to change the date format of the default alias of daily notes.
            alias_format = "%B %-d, %Y",
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = nil,
        },
        -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
        completion = {
            -- Set to false to disable completion.
            nvim_cmp = true,
            -- Trigger completion at 2 chars.
            min_chars = 1,
        },
    },
    keys = {
        { "<leader>oo", "<cmd>ObsidianOpen<cr>",        desc = "Open in Obsidian" },
        { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "Obsidian New" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian Quick Switch" },
        { "<leader>ol", "<cmd>ObsidianFollowLink<cr>",  desc = "Obsidian Folow Link" },
        { "<leader>og", "<cmd>ObsidianTags<cr>",        desc = "Obsidian Tags" },
        { "<leader>ot", "<cmd>ObsidianToday<cr>",       desc = "Obsidian Today" },

    }
}
