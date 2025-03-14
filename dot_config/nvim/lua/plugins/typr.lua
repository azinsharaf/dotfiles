return {
    "nvzone/typr",
    enabled = true,
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
    config = function()
        local keymap = vim.keymap

        -- Keymap for :Typr command
        keymap.set("n", "<leader>t", "<cmd>Typr<CR>", { desc = "Typr" })

        -- Keymap for :TyprStats command
        keymap.set("n", "<leader>s", "<cmd>TyprStats<CR>", { desc = "Typr Stats" })
    end,
}
