-- main branch: the archived master branch does not support nvim 0.12
-- (broken injection parsing: "attempt to call method 'range'").
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        -- norg/norg_meta are built by the neorg spec (see neorg.lua).
        require("nvim-treesitter").install({
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
        })

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                if args.match == "tex" then
                    return -- vimtex's own syntax highlighting is better for tex
                end
                -- Enables highlighting when a parser exists; silently no-op otherwise.
                pcall(vim.treesitter.start, args.buf)
            end,
        })

        -- Folding settings
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
}
