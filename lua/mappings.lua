-- Formatting with LSP
vim.keymap.set("n", "ff", function()
    vim.lsp.buf.format()
end)

vim.keymap.set("i", "jk", "<ESC>", { noremap = true })
vim.keymap.set("i", "kj", "<ESC>", { noremap = true })

-- Delete without yanking
vim.keymap.set("n", "<leader>d", '"_d', { noremap = true })
-- Resize windows
vim.keymap.set("n", "<leader>k", ":resize +2<CR>", { noremap = true })
vim.keymap.set("n", "<leader>j", ":resize -2<CR>", { noremap = true })
vim.keymap.set("n", "<leader>h", ":vertical resize +2<CR>", { noremap = true })
vim.keymap.set("n", "<leader>l", ":vertical resize -2<CR>", { noremap = true })

-- for latex
vim.keymap.set("n", "<leader>lc", ":VimtexCompile<CR>", { silent = true }) -- Compile
vim.keymap.set("n", "<leader>lv", ":VimtexView<CR>", { silent = true }) -- Open PDF in Zathura
vim.keymap.set("n", "<leader>lq", ":VimtexStop<CR>", { silent = true }) -- Stop compilation

-- nvim tree switch toggle
vim.keymap.set("n", "<leader>u", ":NvimTreeToggle<cr>")

-- show warning and error
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
