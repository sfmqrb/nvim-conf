return {
    {
        "ojroques/nvim-osc52",
        config = function()
            require("osc52").setup({
                max_length = 0, -- No length limit
                silent = false, -- Change to true if you don’t want messages
                trim = false, -- Preserve trailing newlines if needed
            })

            vim.api.nvim_create_autocmd("TextYankPost", {
                callback = function()
                    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
                        require("osc52").copy_register("")
                    end
                end,
            })
        end,
    },
}
