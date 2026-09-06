-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- GitHub-style diff colors: green for added/changed, red for removed,
-- with the actually-changed text in a brighter green (DiffText).
-- Merged from github.com/sfmqrb/nvim-conf.
local function github_diff_colors()
  vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#12261e" })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = "#12261e" })
  vim.api.nvim_set_hl(0, "DiffText", { bg = "#1d572d", bold = true })
  vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#301b1f", fg = "#6e4a52" })
end
github_diff_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("github_diff_colors", { clear = true }),
  callback = github_diff_colors,
})
