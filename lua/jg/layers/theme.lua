local layer = require('jg.lib.layer')
local utils = require('jg.lib.utils')

local l = {}

layer.use({
  requires = {
    { 'josa42/theme-theonedark', { rtp = 'dist/vim' } },
  },

  setup = function()
    vim.o.termguicolors = true
    l.setColorScheme('theonedark')

    -- TODO move this into the theme
    vim.cmd([[
      highlight ConflictMarkerBegin               guibg=#2f7366
      highlight ConflictMarkerOurs                guibg=#2e5049
      highlight ConflictMarkerTheirs              guibg=#344f69
      highlight ConflictMarkerEnd                 guibg=#2f628e
      highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
    ]])
  end,
})

function l.setColorScheme(theme)
  if utils.contains(vim.fn.getcompletion('', 'color'), theme) then
    vim.cmd('colorscheme ' .. theme)
  else
    print('[error] colorscheme "' .. theme .. '" not found!')
  end
end
