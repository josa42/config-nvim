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
    keys = {
      {
        '<Tab>',
        function()
          require('copilot.suggestion').accept()
        end,
        mode = { 'i' },
        desc = '[copilot] accept suggestion',
        silent = true,
      },
    },
  },
}
