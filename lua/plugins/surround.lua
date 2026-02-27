return {
  {
    'kylechui/nvim-surround',

    init = function()
      vim.g.nvim_surround_no_mappings = true
    end,

    keys = {
      { 'sa', '<Plug>(nvim-surround-normal)', desc = 'Surround: add (motion)' },
      { 'sa', '<Plug>(nvim-surround-visual)', mode = 'v', desc = 'Surround: add (visual)' },
      { 'sd', '<Plug>(nvim-surround-delete)', desc = 'Surround: delete' },
      { 'sr', '<Plug>(nvim-surround-change)', desc = 'Surround: change' },
    },

    opts = {
      surrounds = {
        v = { add = { '${', '}' } },
      },
    },
  },
}
