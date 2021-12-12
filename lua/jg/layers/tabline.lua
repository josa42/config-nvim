local layer = require('jg.lib.layer')

local function map_tab(idx)
  return function()
    require('tabline').switchTabIdx(idx)
  end
end

layer.use({
  require = { 'josa42/nvim-tabline' },

  map = {
    { 'n', '1', map_tab(1) },
    { 'n', '2', map_tab(2) },
    { 'n', '3', map_tab(3) },
    { 'n', '4', map_tab(4) },
    { 'n', '5', map_tab(5) },
    { 'n', '6', map_tab(6) },
    { 'n', '7', map_tab(7) },
    { 'n', '8', map_tab(8) },
    { 'n', '9', map_tab(9) },
  },
})
