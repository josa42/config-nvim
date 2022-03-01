local layer = require('jg.lib.layer')
local plug = require('jg.lib.plug')
local command = require('jg.lib.command')

command.define('RG', { nargs = '+' }, "lua require('jg.quickfix.tools').rg(<f-args>)")
command.define('FD', { nargs = '+' }, "lua require('jg.quickfix.tools').fd(<f-args>)")

plug.require(
  -- fix performance of CursorHold and CursorHoldI events

  'antoinemadec/FixCursorHold.nvim',

  -- Editing
  'Darazaki/indent-o-matic',
  'josa42/vim-templates',
  'tpope/vim-repeat',

  -- Files
  'tpope/vim-eunuch',
  'jghauser/mkdir.nvim'
)

plug.after(function()
  require('diffview').setup({
    use_icons = false,
  })
  require('indent-o-matic').setup({
    standard_widths = { 2, 4, 8 },
  })
end)

layer.use({
  requires = {
    'sudormrfbin/cheatsheet.nvim',
  },

  setup = function()
    require('cheatsheet').setup({
      bundled_cheatsheets = {
        disabled = { 'lua', 'markdown', 'nerd-fonts', 'netrw', 'regex', 'unicode' },
      },
    })
  end,
})

local l = {}
layer.use({
  map = function()
    return {
      { 'n', 'z=', l.spell_suggest },
    }
  end,
  setup = function()
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
    return l
  end,
})

-- layer.use({
--   requires = { 'zhamlin/tiler.vim' },
-- })
