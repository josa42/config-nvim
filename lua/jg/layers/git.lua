local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'tpope/vim-fugitive', -- Git commands; mainly for Gblame
    'tpope/vim-rhubarb',
    'tpope/vim-git',
    'rhysd/conflict-marker.vim', -- is this this working?
    'sindrets/diffview.nvim', -- still used?
  },

  commands = {
    -- reset file
    -- FIXME force reload buffer
    ResetFile = { 'silent !git checkout HEAD -- %', nargs = 0 },

    -- Open Fork (git client)
    F = 'silent! !fork',
    Ff = 'silent! !fork log -- %',
    Fl = 'silent! !fork log',
    Fs = 'silent! !fork status',
  },
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
