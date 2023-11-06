local function map_tab(idx)
  return function()
    require('tabline').switch_tab_idx(idx)
  end
end

return {
  {
    'josa42/nvim-tabline',

    lazy = false,

    keys = {
      { '<leader>1', map_tab(1) },
      { '<leader>2', map_tab(2) },
      { '<leader>3', map_tab(3) },
      { '<leader>4', map_tab(4) },
      { '<leader>5', map_tab(5) },
      { '<leader>6', map_tab(6) },
      { '<leader>7', map_tab(7) },
      { '<leader>8', map_tab(8) },
      { '<leader>9', map_tab(9) },

      -- select tabs
      { '<Tab>', ':tabnext<CR>', desc = 'Select Next Tab' },
      { '<S-Tab>', ':tabprevious<CR>', desc = 'Select Previous Tab' },

      -- move tabs
      { 'm<Tab>', ':tabm +1<CR>', desc = 'Move Tab Right' },
      { 'm<S-Tab>', ':tabm -1<CR>', desc = 'Move Tab Left' },
    },
  },
}
