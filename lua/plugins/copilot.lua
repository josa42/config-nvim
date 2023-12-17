return {
  {
    'zbirenbaum/copilot.lua',
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
}
