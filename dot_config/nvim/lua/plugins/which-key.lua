return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        delay = 0,
    },

    config = function()
        local wk = require("which-key")
        wk.setup({
            preset = "helix",
            icons = {
                rules = false,
            },
            layout = {
                align = "center",
                spacing = 4,
            },

            win = {
                height = { max = 44 },
                padding = { 1, 1 },
                title_pos = "center",
            },
        })
        wk.add({
            {
                mode = { "n", "v" },
                -- { "<leader><Tab>", group = "tabs" },
                { "<leader>?", group = "Buffer Local Keymaps (which-key)" },
                { "<leader>b", group = "buffer" },
                { "<leader>e", group = "explorer" },
                { "<leader>f", group = "file/find" },
                { "<leader>g", group = "git" },
                { "<leader>o", group = "obsidian" },
                { "<leader>s", group = "split" },
            },
        })
    end,
}
