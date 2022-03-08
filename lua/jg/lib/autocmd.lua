local M = {}

require('jg.lib.polyfills')

-- Usage:
--   au.group('tekkan', function(cmd)
--     cmd({ on = 'BufEnter' }, function()
--       print('wo bist du?')
--     end)
--   end)
function M.group(name, defineCmds)
  local group = vim.api.nvim_create_augroup(name, { clear = true })
  defineCmds(function(options, listener)
    options.group = group
    M.cmd(options, listener)
  end)
end

-- Usage:
--   au.cmd({ on = { 'BufEnter' } }, function()
--     print('enter')
--   end)
--
--   au.cmd({ on = { 'BufEnter' }, pattern = '*.matrix' }, function()
--     print('enter matrix')
--   end)
function M.cmd(options, listener)
  if options == nil or type(options) == 'string' or options.on == nil then
    return print('error: Invalid options')
  end

  vim.api.nvim_create_autocmd(options.on, {
    group = options.group,
    pattern = options.pattern,
    [type(listener) == 'function' and 'callback' or 'command'] = listener,
  })
end

return M
