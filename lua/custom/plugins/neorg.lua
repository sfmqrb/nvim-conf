return {
    "nvim-neorg/neorg",
    lazy = false, -- Load eagerly to avoid race conditions
    version = "*",
    -- norg parsers are not in nvim-treesitter main's registry and norg's
    -- scanner is C++, which `tree-sitter build` no longer compiles. Build them
    -- here into <plugin>/parser/, which is already on the runtimepath.
    build = "mkdir -p parser && for p in norg norg_meta; do"
        .. " d=$(mktemp -d) && git clone -q --depth 1 https://github.com/nvim-neorg/tree-sitter-$(echo $p | tr _ -) $d"
        .. " && cc -O2 -shared -fPIC -I$d/src $(ls $d/src/parser.c $d/src/scanner.c* 2>/dev/null) -lstdc++ -o parser/$p.so"
        .. " && rm -rf $d || exit 1; done",
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required by Neorg
        "hrsh7th/nvim-cmp", -- Required for nvim-cmp integration
        "nvim-treesitter/nvim-treesitter",
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
