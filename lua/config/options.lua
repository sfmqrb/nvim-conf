-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

-- Keep LazyVim autoformat off: formatting is manual via `ff` / `<leader>cf`
-- (see lua/plugins/personal-format.lua).
vim.g.autoformat = false

-- Personal editing preferences (merged from github.com/sfmqrb/nvim-conf)
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.breakindent = true

-- Set explicitly rather than append: nvim's default diffopt already has
-- linematch:40, and a duplicate linematch entry silently disables word-level
-- DiffText highlighting. followwrap keeps long lines wrapping in diff mode.
vim.opt.diffopt = "internal,filler,closeoff,linematch:60,followwrap,algorithm:histogram"
