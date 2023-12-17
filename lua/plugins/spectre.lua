return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-pack/nvim-spectre' },

    keys = function()
      local spectre = require('spectre')
      local map = require('config.utils.map')

      return map.keys('s', 'Search and replace', function(cwd)
        spectre.open({
          cwd = cwd,
          is_close = true, -- close an exists instance of spectre and open new
        })
      end)
    end,
  },
}
