-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Personal keymaps merged from github.com/sfmqrb/nvim-conf

local map = vim.keymap.set

-- Escape from insert mode
map("i", "jk", "<ESC>", { noremap = true })
map("i", "kj", "<ESC>", { noremap = true })

-- Delete without yanking (shadows the dap <leader>d prefix; no dap in the old config)
map({ "n", "x" }, "<leader>d", '"_d', { noremap = true, desc = "Delete (black hole)" })

-- Manual LSP format (autoformat is off)
map("n", "ff", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- (window resize: LazyVim already binds <C-Up/Down/Left/Right>)

-- File tree (neo-tree) -- old muscle memory
map("n", "<leader>u", "<cmd>Neotree toggle<CR>", { desc = "Explorer (toggle)" })
map("n", "<leader>o", "<cmd>Neotree reveal<CR>", { desc = "Explorer (reveal file)" })

-- Diagnostics for the current line, in a float
local function line_diagnostics()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  if #vim.diagnostic.get(0, { lnum = lnum }) == 0 then
    vim.notify("No warnings or errors on this line", vim.log.levels.INFO)
    return
  end
  vim.diagnostic.open_float()
end
map("n", "<leader>e", line_diagnostics, { desc = "Line diagnostics (float)" })
map("n", "gl", line_diagnostics, { desc = "Line diagnostics (float)" })

-- Jump to next/prev diagnostic and show it
map("n", "]e", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "[e", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })

-- gitsigns: old hunk-nav aliases (LazyVim also binds ]h / [h) + word-diff toggle
map("n", "]c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    require("gitsigns").nav_hunk("next")
  end
end, { desc = "Next git hunk" })
map("n", "[c", function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    require("gitsigns").nav_hunk("prev")
  end
end, { desc = "Prev git hunk" })
map("n", "<leader>hw", "<cmd>Gitsigns toggle_word_diff<CR>", { desc = "Toggle word diff" })

-- todo-comments (LazyVim ships the plugin)
map("n", "tdl", "<cmd>TodoLocList<CR>", { noremap = true, silent = true, desc = "Todo loclist" })

-- vimtex (only in tex buffers, so they don't clutter the global which-key)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex", "bib" },
  callback = function(ev)
    local o = { silent = true, buffer = ev.buf }
    map("n", "<leader>lc", "<cmd>VimtexCompile<CR>", vim.tbl_extend("force", o, { desc = "Vimtex compile toggle" }))
    map("n", "<leader>lv", "<cmd>VimtexView<CR>", vim.tbl_extend("force", o, { desc = "Vimtex view PDF" }))
    map("n", "<leader>lq", "<cmd>VimtexStop<CR>", vim.tbl_extend("force", o, { desc = "Vimtex stop" }))
    map("n", "<leader>le", "<cmd>VimtexErrors<CR>", vim.tbl_extend("force", o, { desc = "Vimtex errors" }))
    map("n", "<leader>lt", "<cmd>VimtexTocToggle<CR>", vim.tbl_extend("force", o, { desc = "Vimtex TOC" }))
    map("n", "<leader>lx", "<cmd>VimtexClean<CR>", vim.tbl_extend("force", o, { desc = "Vimtex clean" }))
  end,
})
