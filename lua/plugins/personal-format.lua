-- Formatters merged from github.com/sfmqrb/nvim-conf.
-- Autoformat stays off (vim.g.autoformat = false in config/options.lua);
-- format on demand with `ff` or `<leader>cf`.
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        lua = { "stylua" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = {
            "-style={BasedOnStyle: llvm, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "black", "clang-format", "stylua" })
    end,
  },
}
