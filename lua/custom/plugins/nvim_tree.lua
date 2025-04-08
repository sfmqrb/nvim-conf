return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            view = {
                width = 40,
                side = "left",
                preserve_window_proportions = true,
            },
        })
    end,
}
