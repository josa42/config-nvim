local layer = require('jg.lib.layer')

-- Draw diagrams
-- keep forgetting about this...
layer.use({
  requires = {
    'jbyuki/venn.nvim',
    'xorid/asciitree.nvim',
  },
  map = function()
    return {
      {
        'n',
        '<leader>v',
        function()
          if not vim.b.venn_enabled then
            vim.b.venn_enabled = true
            vim.opt_local.virtualedit = 'all'
            -- draw a line on HJKL keystokes
            vim.api.nvim_buf_set_keymap(0, 'n', 'J', '<C-v>j:VBox<CR>', { noremap = true })
            vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<C-v>k:VBox<CR>', { noremap = true })
            vim.api.nvim_buf_set_keymap(0, 'n', 'L', '<C-v>l:VBox<CR>', { noremap = true })
            vim.api.nvim_buf_set_keymap(0, 'n', 'H', '<C-v>h:VBox<CR>', { noremap = true })
            -- draw a box by pressing "f" with visual selection
            vim.api.nvim_buf_set_keymap(0, 'v', 'f', ':VBox<CR>', { noremap = true })
          else
            vim.opt_local.virtualedit = ''
            vim.cmd.mapclear('<buffer>')
            vim.b.venn_enabled = nil
          end
        end,
      },
    }
  end,

  setup = function()
    require('asciitree').setup({
      delimiter = '-',
    })
  end,
})
