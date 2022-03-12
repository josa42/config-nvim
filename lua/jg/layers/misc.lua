-- TODO split this layer up

local layer = require('jg.lib.layer')
local command = require('jg.lib.command')

command.define('RG', { nargs = '+' }, "lua require('jg.quickfix.tools').rg(<f-args>)")
command.define('FD', { nargs = '+' }, "lua require('jg.quickfix.tools').fd(<f-args>)")

layer.use({
  requires = {
    -- fix performance of CursorHold and CursorHoldI events
    'antoinemadec/FixCursorHold.nvim',

    -- Editing
    'Darazaki/indent-o-matic',
    'josa42/vim-templates',
    'tpope/vim-repeat',

    -- Files
    'tpope/vim-eunuch',
    'jghauser/mkdir.nvim',
  },

  setup = function()
    require('diffview').setup({
      use_icons = false,
    })
    require('indent-o-matic').setup({
      standard_widths = { 2, 4, 8 },
    })
  end,
})

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

layer.use({
  requires = { 'jbyuki/venn.nvim' },
  map = function()
    return {
      {
        'n',
        '<leader>v',
        function()
          if not vim.b.venn_enabled then
            vim.b.venn_enabled = true
            vim.cmd([[setlocal ve=all]])
            -- draw a line on HJKL keystokes
            vim.api.nvim_buf_set_keymap(0, 'n', 'J', '<C-v>j:VBox<CR>', { noremap = true })
            vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<C-v>k:VBox<CR>', { noremap = true })
            vim.api.nvim_buf_set_keymap(0, 'n', 'L', '<C-v>l:VBox<CR>', { noremap = true })
            vim.api.nvim_buf_set_keymap(0, 'n', 'H', '<C-v>h:VBox<CR>', { noremap = true })
            -- draw a box by pressing "f" with visual selection
            vim.api.nvim_buf_set_keymap(0, 'v', 'f', ':VBox<CR>', { noremap = true })
          else
            vim.cmd([[setlocal ve=]])
            vim.cmd([[mapclear <buffer>]])
            vim.b.venn_enabled = nil
          end
        end,
      },
    }
  end,
})

-- layer.use({
--   requires = { 'zhamlin/tiler.vim' },
-- })
