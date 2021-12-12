local layer = require('jg.lib.layer')
local hi = require('jg.lib.highlight')
local command = require('jg.lib.command')

layer.use({
  require = {
    'tpope/vim-fugitive', -- Git commands; mainly Gblame
    'tpope/vim-rhubarb',
    'tpope/vim-git',
    'rhysd/conflict-marker.vim',
    'sindrets/diffview.nvim',
  },

  before = function()
    -- reset file
    command.define('ResetFile', { nargs = 0 }, 'silent !git checkout HEAD -- %')

    -- Open Fork (git client)
    command.define('F', {}, 'silent! !fork')
    command.define('Ff', {}, 'silent! !fork log -- %')
    command.define('Fl', {}, 'silent! !fork log')
    command.define('Fs', {}, 'silent! !fork status')

    hi.set('ConflictMarkerBegin', { bg = '#2f7366' })
    hi.set('ConflictMarkerOurs', { bg = '#2e5049' })
    hi.set('ConflictMarkerTheirs', { bg = '#344f69' })
    hi.set('ConflictMarkerEnd', { bg = '#2f628e' })
    hi.set('ConflictMarkerCommonAncestorsHunk', { bg = '#754a81' })
  end,
})

layer.use({
  require = {
    'nvim-lua/plenary.nvim',
    'lewis6991/gitsigns.nvim',
  },

  after = function()
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
