local M = {}

  local utils = require('jg.lib.utils')

-- Usage:
--   au.group('tekkan', function(cmd)
--     cmd({ on = 'BufEnter' }, function()
--       print('wo bist du?')
--     end)
--   end)
function M.group(name, defineCmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  defineCmds(M.cmd)
  vim.cmd('augroup end')
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
  if options == nil or options.on == nil or listener == nil then
    print('error: Invalid autocmd')
    return
  end

  if type(options) == 'string' then options = { on = options } end
  if type(options.on) == 'string' then options.on = { options.on } end
  if type(options.pattern) == 'table' then options.pattern = table.concat(options.pattern, ',') end
  if type(options.pattern) ~= 'string' then options.pattern = '*' end

  if type(listener) ~= 'string' and type(listener) ~= 'function' then
    print('error: Invalid listener type: ' .. type(listener))
    return
  end

  local on = table.concat(options.on, ',')

  vim.cmd(table.concat({ 'autocmd', on, options.pattern, utils.wrapFunction('aucmd', listener) }, ' '))
end

return M
