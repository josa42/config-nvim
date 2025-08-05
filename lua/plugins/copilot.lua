return {
  {
    'zbirenbaum/copilot.lua',

    events = { 'InsertEnter' },

    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
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
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for rest
      prompts = {
        ShowTSProps = {
          prompt = 'convert proptypes to ts type, while keeping the comments. print only the props interface',
          system_prompt = 'You are very good at explaining stuff',
          -- mapping = '<leader>ccmc',
          -- description = 'My custom prompt description',
        },
        RefactorTSProps = {
          prompt = 'convert proptypes to ts type. keeping the comments, but do not write new comments. Extend the props that are spread into the PropType definitions. Use the <Component>Props do not infer parent prop types. Do not extend base props if they are not spread into the PropType definitions. remove all proptypes from the component. DO NOT EXTEND NAVIVE element props',
          system_prompt = 'You are very good at explaining stuff',
          mapping = '<leader>xp',
          -- description = 'My custom prompt description',
        },
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
