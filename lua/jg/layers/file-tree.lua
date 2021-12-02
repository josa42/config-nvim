local layer = require('jg.lib.layer')

layer.use({
  enabled = false,

  require = { { 'josa42/nvim-filetree', { tag = '*' } } },

  map = {
    { 'n', '<leader>b', ':call TreeToggleSmart()<CR>' },
    { 'n', '<leader>B', ':call TreeClose()<CR>' },
  },
})

layer.use({
  enabled = true,

  require = { { 'kyazdani42/nvim-tree.lua' } },

  map = {
    { 'n', '<leader>b', ':NvimTreeToggle<CR>' },
  },

  before = function()
    vim.g.nvim_tree_show_icons = {
      git = 0,
      folders = 1,
      files = 1,
      folder_arrows = 0,
    }

    vim.g.nvim_tree_icons = {
      default = '',
    }

    vim.g.nvim_tree_special_files = {}
  end,

  after = function()
    require('nvim-tree').setup({
      view = {
        hide_root_folder = true,
      },
      filters = {
        custom = { '.git' },
      },
    })

    vim.cmd([[
      hi! link NvimTreeFolderIcon  NvimTreeFolderName
      hi! link NvimTreeExecFile    NvimTreeNormal
      hi! link NvimTreeSpecialFile NvimTreeNormal
      hi! link NvimTreeImageFile   NvimTreeNormal
      hi! link NvimTreeOpenedFile  NvimTreeNormal
    ]])
  end,
})
