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

-- for latex (vimtex)
vim.keymap.set("n", "<leader>lc", ":VimtexCompile<CR>", { silent = true }) -- Toggle continuous compile
vim.keymap.set("n", "<leader>lv", ":VimtexView<CR>", { silent = true }) -- Open PDF viewer
vim.keymap.set("n", "<leader>lq", ":VimtexStop<CR>", { silent = true }) -- Stop compilation
vim.keymap.set("n", "<leader>le", ":VimtexErrors<CR>", { silent = true }) -- Show errors in quickfix
vim.keymap.set("n", "<leader>lt", ":VimtexTocToggle<CR>", { silent = true }) -- Table of contents
vim.keymap.set("n", "<leader>lx", ":VimtexClean<CR>", { silent = true }) -- Clean aux files

-- nvim tree switch toggle
vim.keymap.set("n", "<leader>u", ":NvimTreeToggle<cr>")

-- show warning and error for current line (nvim-tree reveal moved to <leader>o)
local function line_diagnostics()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    if #vim.diagnostic.get(0, { lnum = lnum }) == 0 then
        vim.notify("No warnings or errors on this line", vim.log.levels.INFO)
        return
    end
    vim.diagnostic.open_float()
end
vim.keymap.set("n", "<leader>e", line_diagnostics)
vim.keymap.set("n", "gl", line_diagnostics)

-- jump to next/previous warning or error and show it in a popup
vim.keymap.set("n", "]e", function()
    vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "[e", function()
    vim.diagnostic.jump({ count = -1, float = true })
end)

-- quickfix navigation (e.g. jump between LaTeX compile errors)
vim.keymap.set("n", "]q", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "[q", ":cprev<CR>", { silent = true })
