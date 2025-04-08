return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        indent = { char = "┊" },
        whitespace = {
            highlight = {
                "Whitespace",
            },
            remove_blankline_trail = false,
        },
        scope = {
            show_start = true,
            show_end = false,
            injected_languages = false,
            highlight = { "Function", "Label" },
            priority = 500,
            enabled = false,
        },
    },
}
