-- Copilot inline suggestions, merged from github.com/sfmqrb/nvim-conf.
-- The ai.copilot extra installs copilot.lua and wires it as a completion
-- source; this re-enables the inline ghost-text suggestion with the old
-- keymaps and filetype opt-outs.
return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      tex = false,
      plaintex = false,
      bib = false,
      json = false,
      yaml = false,
      text = false,
      ["*"] = true,
    },
  },
}
