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
    ResetFile = { 'silent !git checkout HEAD -- %', nargs = 0, label = 'Reset current file' },

    -- Open Fork (git client)
    F = { 'silent! !fork', label = 'Open Fork' },
    Ff = { 'silent! !fork log -- %', label = 'Open Fork - log current file' },
    Fl = { 'silent! !fork log', label = 'Open Fork - log' },
    Fs = { 'silent! !fork status', label = 'Open Fork - status' },
  },
})

layer.use({
  requires = {
    { 'lewis6991/gitsigns.nvim', { requires = 'nvim-lua/plenary.nvim' } },
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
