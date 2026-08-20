return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        -- norg_meta is not in nvim-treesitter's registry; neorg needs it (norg is in the registry)
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.norg_meta = {
            install_info = {
                url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
                files = { "src/parser.c" },
                branch = "main",
            },
        }

        configs.setup({
            ensure_installed = {
                "norg",
                "norg_meta",
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
            ignore_install = { "latex" }, -- needs tree-sitter CLI; vimtex highlights tex instead
            highlight = {
                enable = true,
                disable = { "latex" }, -- vimtex's own syntax highlighting is better for tex
            },
            indent = { enable = true },
            fold = { enable = true },
        })

        -- Folding settings
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "nvim_treesitter#foldexpr()"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
}

