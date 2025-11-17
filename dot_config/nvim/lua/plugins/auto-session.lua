vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

return {
    "rmagatti/auto-session",
    enabled = true,
    lazy = false,
    keys = {
        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
        { "<leader>ws", "<cmd>AutoSession save<CR>",   desc = "Save session" },
        { "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
    },
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        -- Saving / restoring
        enabled = true,                    -- Enables/disables auto creating, saving and restoring
        auto_save = true,                  -- Enables/disables auto saving session on exit
        auto_restore = true,               -- Enables/disables auto restoring session on start
        auto_create = true,                -- Enables/disables auto creating new session files. Can be a function that returns true if a new session file should be allowed
        auto_restore_last_session = false, -- On startup, loads the last saved session if session for cwd does not exist
        cwd_change_handling = false,       -- Automatically save/restore sessions when changing directories
        single_session_mode = false,       -- Enable single session mode to keep all work
    },
}
