return {
  {
    'zbirenbaum/copilot.lua',

    events = { 'InsertEnter' },

    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = false,
      },
      panel = { enabled = false },
    },

    keys = function()
      if not pcall(require, 'cmp') then
        return {
          '<c-e>',
          function()
            local copilot = require('copilot.suggestion')
            if copilot.is_visible() then
              copilot.accept()
            end
          end,
          mode = { 'i' },
          desc = '[copilot] accept suggestion',
          silent = true,
        }
      end
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
