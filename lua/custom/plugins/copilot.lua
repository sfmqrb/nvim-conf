return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true, -- Optional: Enable suggestions without explicit trigger
          keymap = {
            accept = "<C-l>", -- Set <C-l> to accept Copilot suggestions
            accept_word = false, -- Disable word-level acceptance (optional)
            accept_line = false, -- Disable line-level acceptance (optional)
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        -- Other Copilot settings (keep your existing panel/filetype configs)
      })
    end,
}
