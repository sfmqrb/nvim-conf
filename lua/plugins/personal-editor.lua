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
    init = function()
      -- neorg's rockspec builds norg/norg_meta via luarocks into lazy-rocks/,
      -- but lazy.nvim doesn't put that parser/ dir on the runtimepath, so
      -- treesitter never finds them. Add it here.
      local rocks = vim.fn.stdpath("data") .. "/lazy-rocks/"
      vim.opt.runtimepath:append(rocks .. "tree-sitter-norg/lib/lua/5.1")
      vim.opt.runtimepath:append(rocks .. "tree-sitter-norg-meta/lib/lua/5.1")
    end,
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = { config = { workspaces = { notes = "~/.notes" } } },
        -- core.completion dropped: it needs nvim-cmp, and this config uses
        -- blink.cmp. Re-add with a blink engine if neorg ships one.
      },
    },
  },
}
