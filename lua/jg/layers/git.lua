local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'tpope/vim-fugitive', -- Git commands; mainly for Gblame
    'tpope/vim-rhubarb',
    'tpope/vim-git',
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
  enabled = false,
  requires = {
    'rhysd/conflict-marker.vim',
  },
})

layer.use({
  enabled = true,
  requires = {
    'akinsho/git-conflict.nvim',
  },
  setup = function()
    require('git-conflict').setup({
      default_mappings = false,
      highlights = {
        current = 'DiffText',
        incoming = 'DiffAdd',
        ancestor = 'DiffAncestor',
      },
    })
  end,

  map = {
    { 'n', 'co', '<Plug>(git-conflict-ours)' },
    { 'n', 'cb', '<Plug>(git-conflict-both)' },
    { 'n', 'c0', '<Plug>(git-conflict-none)' },
    { 'n', 'ct', '<Plug>(git-conflict-theirs)' },
    { 'n', 'cn', '<Plug>(git-conflict-next-conflict)' },
    { 'n', 'np', '<Plug>(git-conflict-prev-conflict)' },
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

    vim.cmd([[hi ConflictMarkerCommonAncestorsHunk guibg=#4F3058]])
  end,
})

layer.use({
  enabled = false,
  requires = {
    'pwntester/octo.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- 'kyazdani42/nvim-web-devicons',
  },
  setup = function()
    require('octo').setup()
  end,
})

layer.use({
  enabled = false,
  requires = {
    'pwntester/octo.nvim',
  },
})

layer.use({
  enabled = false,
  requires = {
    'ldelossa/litee.nvim',
    'ldelossa/gh.nvim',
  },

  setup = function()
    require('litee.lib').setup()
    require('litee.gh').setup()
  end,
})

layer.use({
  enabled = false,
  requires = {
    'pwntester/octo.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- 'kyazdani42/nvim-web-devicons',
  },
  setup = function()
    require('octo').setup()
  end,
})
