return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local gs = require 'gitsigns'
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigate between changed hunks
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gs.nav_hunk 'next'
          end
        end, 'Next git hunk')
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gs.nav_hunk 'prev'
          end
        end, 'Previous git hunk')

        -- View the actual diff
        map('n', '<leader>hp', gs.preview_hunk_inline, 'Preview hunk inline (old lines shown in place)')
        map('n', '<leader>hP', gs.preview_hunk, 'Preview hunk in floating window')
        map('n', '<leader>hd', gs.diffthis, 'Diff buffer vs index (side by side)')
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, 'Diff buffer vs last commit')

        -- Persistent visual aids (toggles)
        map('n', '<leader>hw', gs.toggle_word_diff, 'Toggle word-level diff highlight')
        map('n', '<leader>hl', gs.toggle_linehl, 'Toggle changed-line background highlight')
        map('n', '<leader>ht', gs.toggle_deleted, 'Toggle deleted lines shown inline')

        -- Stage / undo hunks while reviewing
        map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
      end,
    }
  end,
}
