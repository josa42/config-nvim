local layer = require('jg.lib.layer')

local l = {}

layer.use({
  requires = {
    { 'josa42/theme-theonedark', rtp = 'dist/vim' },
  },

  setup = function()
    vim.o.termguicolors = true
    l.setColorScheme('theonedark')
  end,
})

function l.setColorScheme(theme)
  if vim.tbl_contains(vim.fn.getcompletion('', 'color'), theme) then
    vim.cmd('colorscheme ' .. theme)
  else
    print('[error] colorscheme "' .. theme .. '" not found!')
  end
end
