return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "elixir",
                "javascript",
                "html",
                "python",
                "typescript",
                "java",
                "bash",
                "cmake",
                "cpp",
                "cuda",
                "dockerfile",
                "ini",
                "json",
                "make",
                "markdown",
                "markdown_inline",
                "rust",
                "sql",
                "terraform",
                "toml",
                "yaml",
            },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
