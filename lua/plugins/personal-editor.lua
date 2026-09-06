-- Extra plugins with no LazyVim equivalent, merged from
-- github.com/sfmqrb/nvim-conf. (Comment.nvim, indent-blankline, which-key,
-- todo-comments, gitsigns, telescope, zen-mode, nvim-cmp, osc52 and the
-- midnight theme were dropped: LazyVim / Omarchy already provide them.)
return {
  -- matchup: %-navigate begin/end, if/endif, tags, etc.
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- fugitive: :Git blame / :Gdiffsplit / :Gread — buffer-level git, alongside
  -- LazyVim's lazygit.
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Gblame", "Gclog", "Gedit" },
  },

  -- leetcode.nvim
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate",
    cmd = "Leet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
  },

  -- neorg
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.completion"] = { config = { engine = { module_name = "external.lsp-completion" } } },
        ["core.integrations.lsp-completion"] = {},
        ["core.dirman"] = { config = { workspaces = { notes = "~/.notes" } } },
      },
    },
  },
}
