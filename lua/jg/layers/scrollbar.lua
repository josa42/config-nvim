local layer = require('jg.lib.plug')
local au = require('jg.lib.autocmd')

layer.use {
  require = { 'Xuyuanp/scrollbar.nvim' },

  before = function()
    vim.g.scrollbar_right_offset = 0
    -- vim.g.scrollbar_min_size = 5
    vim.g.scrollbar_shape = {
      head = '',
      body = '█',
      tail = '',
    }

    vim.g.scrollbar_highlight = {
      head = 'LineNr',
      body = 'LineNr',
      tail = 'LineNr',
    }

    vim.g.scrollbar_excluded_filetypes = { 'nerdtree', 'tagbar', 'tree' }
  end,

  after = function()
    local scrollbar = require('scrollbar')

    au.group('scrollbar', function(cmd)
      cmd({ on = { 'CursorMoved', 'VimResized', 'QuitPre' }, silent = true }, scrollbar.show)
      cmd({ on = { 'WinEnter', 'FocusGained' }, silent = true }, scrollbar.show)
      cmd({ on = { 'WinLeave', 'FocusLost', 'BufLeave','FocusLost', 'VimResized', 'QuitPre' }, silent = true }, scrollbar.clear)
    end)
  end,
}
