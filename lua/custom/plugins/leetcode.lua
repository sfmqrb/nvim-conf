return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate", -- if you have `nvim-treesitter` installed
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        -- configuration goes here
    },
    cmd = "Leet",
    lazy = true,
}
