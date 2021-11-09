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
    'nvim-lua/plenary.nvim',
    'lewis6991/gitsigns.nvim',
  },

  map = {
    { 'n', '<leader>bt', '<cmd>Gitsigns toggle_current_line_blame<cr>' },
    { 'n', '<leader>bb', '<cmd>lua require"gitsigns".blame_line(true)<CR>' },
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

  after = function()
    require('gitsigns').setup({
      yadm = { enable = true },
    })
  end,
})
