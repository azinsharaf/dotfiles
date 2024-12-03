return {
    "gelguy/wilder.nvim",
    enabled = true,
    config = function()
        local wilder = require("wilder")
        wilder.setup({ modes = { ":", "/", "?" } })

        wilder.set_option("pipeline", {
            wilder.branch(wilder.cmdline_pipeline(), wilder.search_pipeline()),
        })

        wilder.set_option(
            "renderer",
            wilder.wildmenu_renderer({
                highlighter = wilder.basic_highlighter(),
            })
        )
    end,
}