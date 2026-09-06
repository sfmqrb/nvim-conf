-- Per-server LSP tweaks merged from github.com/sfmqrb/nvim-conf.
-- clangd / gopls / basedpyright defaults from the LazyVim lang extras already
-- match the old config, so only the deltas live here.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = { onSave = false }, -- vimtex drives compilation
              chktex = { onOpenAndSave = true },
            },
          },
        },
      },
    },
  },

  -- Rust: check with clippy on save (LazyVim's rust extra enables checkOnSave
  -- but leaves the command at the default "check").
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      },
    },
  },

  -- Java: bump the jdtls heap like the old config did.
  {
    "mfussenegger/nvim-jdtls",
    optional = true,
    opts = function(_, opts)
      opts.cmd = opts.cmd or { vim.fn.exepath("jdtls") }
      table.insert(opts.cmd, "--jvm-arg=-Xmx2G")
    end,
  },
}
