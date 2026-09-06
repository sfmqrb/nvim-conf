-- blink.cmp keymaps to match the old nvim-cmp muscle memory:
-- <Tab>/<S-Tab> cycle the menu (and jump snippet fields), <CR> confirms.
-- Copilot ghost text is accepted with <C-l> (see personal-copilot.lua),
-- so <Tab> stays free for the completion menu.
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    },
  },
}
