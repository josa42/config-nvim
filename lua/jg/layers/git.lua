local layer = require('jg.lib.layer')
local command = require('jg.lib.command')

layer.use({
  requires = {
    'tpope/vim-fugitive', -- Git commands; mainly for Gblame
    'tpope/vim-rhubarb',
    'tpope/vim-git',
    'rhysd/conflict-marker.vim', -- is this this working?
    'sindrets/diffview.nvim', -- still used?
  },

  init = function()
    -- reset file
    -- FIXME force reload buffer
    command.define('ResetFile', { nargs = 0 }, 'silent !git checkout HEAD -- %')

    -- Open Fork (git client)
    command.define('F', {}, 'silent! !fork')
    command.define('Ff', {}, 'silent! !fork log -- %')
    command.define('Fl', {}, 'silent! !fork log')
    command.define('Fs', {}, 'silent! !fork status')
  end,
})

layer.use({
  requires = {
    'nvim-lua/plenary.nvim',
    'lewis6991/gitsigns.nvim',
  },

  setup = function()
    require('gitsigns').setup({
      yadm = { enable = true },
      current_line_blame = false,
      current_line_blame_opts = {
        ignore_whitespace = true,
      },
      preview_config = {
        border = 'rounded',
      },
    })
  end,
})
