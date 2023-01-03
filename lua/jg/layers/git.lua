local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'tpope/vim-fugitive', -- Git commands; mainly for Gblame
    'tpope/vim-rhubarb',
    'tpope/vim-git',
    { 'sindrets/diffview.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  },

  commands = {
    -- reset file
    ResetFile = {
      function()
        vim.fn.system('git checkout HEAD -- ' .. vim.fn.expand('%'))
        vim.cmd.edit({ bang = true })
      end,
      nargs = 0,
    },

    -- Open Fork (git client)
    F = { 'silent! !fork', label = 'Open Fork' },
    Ff = { 'silent! !fork log -- %', label = 'Open Fork - log current file' },
    Fl = { 'silent! !fork log', label = 'Open Fork - log' },
    Fs = { 'silent! !fork status', label = 'Open Fork - status' },
  },

  setup = function()
    require('diffview').setup({
      use_icons = false,
    })
  end,
})

layer.use({
  enabled = true,
  requires = {
    'akinsho/git-conflict.nvim',
  },
  setup = function()
    vim.api.nvim_set_hl(0, 'DiffText', { link = 'Normal', default = true })
    vim.api.nvim_set_hl(0, 'DiffAdd', { link = 'Normal', default = true })
    vim.api.nvim_set_hl(0, 'DiffAncestor', { link = 'Normal', default = true })

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
    { 'n', 'co', '<Plug>(git-conflict-ours)', desc = 'Conflict: use ours' },
    { 'n', 'cb', '<Plug>(git-conflict-both)', desc = 'Conflict: use both' },
    { 'n', 'c0', '<Plug>(git-conflict-none)', desc = 'Conflict: use none' },
    { 'n', 'ct', '<Plug>(git-conflict-theirs)', desc = 'Conflict: use theirs' },
    { 'n', 'cn', '<Plug>(git-conflict-next-conflict)', desc = 'Conflict: next' },
    { 'n', 'cp', '<Plug>(git-conflict-prev-conflict)', desc = 'Conflict: previous' },
  },
})

layer.use({
  requires = {
    { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  },

  setup = function()
    require('gitsigns').setup({
      yadm = { enable = true },
      current_line_blame = false,
      current_line_blame_opts = {
        ignore_whitespace = true,
      },
      preview_config = {
        border = 'single',
      },
    })
  end,
})

layer.use({
  requires = {
    { 'josa42/nvim-blame', dev = true },
  },
})

layer.use({
  map = {
    { 'n', '<leader>gg', ':tabe term://lazygit | startinsert<cr>' },
  },
})
