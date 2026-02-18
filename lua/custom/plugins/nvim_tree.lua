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
            update_focused_file = {    -- added
                enable = true,
                update_cwd = true,
            },
        })

        -- your exact request: toggle with <leader>u
        vim.keymap.set("n", "<leader>u", ":NvimTreeToggle<CR>")

        -- reveal current file and expand folders with <leader>e  (added)
        vim.keymap.set("n", "<leader>e", function()
            require("nvim-tree.api").tree.open()
            require("nvim-tree.api").tree.find_file({ open = true })
        end)
    end,
}

