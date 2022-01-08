local layer = require('jg.lib.layer')

local function map_tab(idx)
  return function()
    require('tabline').switchTabIdx(idx)
  end
end

layer.use({
  requires = { 'josa42/nvim-tabline' },

  map = {
    { 'n', '<leader>1', map_tab(1) },
    { 'n', '<leader>2', map_tab(2) },
    { 'n', '<leader>3', map_tab(3) },
    { 'n', '<leader>4', map_tab(4) },
    { 'n', '<leader>5', map_tab(5) },
    { 'n', '<leader>6', map_tab(6) },
    { 'n', '<leader>7', map_tab(7) },
    { 'n', '<leader>8', map_tab(8) },
    { 'n', '<leader>9', map_tab(9) },
  },
})
