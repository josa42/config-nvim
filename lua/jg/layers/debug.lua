_G.D = function(a)
  print(vim.inspect(a))
end

local layer = require('jg.lib.layer')
layer.use({
  require = { 'nvim-lua/plenary.nvim' },
})
