return {
    "nvzone/typr",
    enabled = true,
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
    config = function()
        local keymap = vim.keymap

        -- Ensure keymap is set correctly
        keymap.set("n", "<leader>t", "<cmd>Typr<CR>", { desc = "Typr" })
        keymap.set("n", "<leader>s", "<cmd>TyprStats<CR>", { desc = "Typr Stats" })
    end,
}
