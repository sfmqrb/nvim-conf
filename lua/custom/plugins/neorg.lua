return {
    "nvim-neorg/neorg",
    lazy = false, -- Load eagerly to avoid race conditions
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required by Neorg
        "hrsh7th/nvim-cmp", -- Required for nvim-cmp integration
    },
    config = function()
        require("neorg").setup({
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.integrations.nvim-cmp"] = {},
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp",
                    },
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/.notes",
                        },
                    },
                },
            },
        })
    end,
}
