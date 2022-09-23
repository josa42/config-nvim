local layer = require('jg.lib.layer')

local l = {}
layer.use({
  map = function()
    return {
      {
        'n',
        'z=',
        l.spell_suggest,
        desc = 'Suggest spell correction',
      },
      -- toggle spell checker
      {
        { 'n', 'i' },
        '<c-s>',
        function()
          vim.wo.spell = not vim.wo.spell
        end,
        desc = 'Toggle Spell Checking',
      },
    }
  end,
  setup = function()
    -- Spell check
    vim.opt.spell = false
    vim.opt.spelllang = { 'en_gb', 'en_us', 'de_20' }

    -- use vim.ui.select() for spell suggestions
    function l.spell_suggest()
      vim.ui.select(
        vim.fn.spellsuggest(vim.fn.expand('<cword>')),
        { width = 40, max_height = 10, relative = 'cursor', position = 1 },
        function(word)
          if word then
            vim.cmd('normal! ciw' .. word)
            vim.cmd('stopinsert')
          end
        end
      )
    end
  end,
})
