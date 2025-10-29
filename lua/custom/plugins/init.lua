-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- Iron nvim
return {
  'hkupty/iron.nvim',
  config = function()
    local iron = require 'iron.core'

    iron.setup {
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { 'bash' },
          },
          python = {
            command = { 'ipython' },
          },
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = require('iron.view').right(60),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        send_motion = '<space>Sc',
        visual_send = '<space>Sc',
        send_file = '<space>Sf',
        send_line = '<space>Sl',
        send_mark = '<space>Sm',
        mark_motion = '<space>mc',
        mark_visual = '<space>mc',
        remove_mark = '<space>md',
        cr = '<space>S<cr>',
        interrupt = '<space>S<space>',
        exit = '<space>Sq',
        clear = '<space>cl',
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
    vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
    vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
    vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
  end,
}
