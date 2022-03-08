local M = {}
local l = {}

local utils = require('jg.lib.utils')

local need_polyfix = type(vim.api.nvim_create_autocmd) ~= 'function' or type(vim.api.nvim_create_augroup) ~= 'function'

-- Usage:
--   au.group('tekkan', function(cmd)
--     cmd({ on = 'BufEnter' }, function()
--       print('wo bist du?')
--     end)
--   end)
function M.group(name, defineCmds)
  if need_polyfix then
    vim.cmd('augroup ' .. name)
    vim.cmd('autocmd!')
    defineCmds(M.cmd)
    vim.cmd('augroup end')
    return
  end

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

  if type(listener) ~= 'string' and type(listener) ~= 'function' then
    return print('error: Invalid listener type: ' .. type(listener))
  end

  if need_polyfix then
    local pattern = l.try_concat(options.pattern) or '*'
    local on = l.try_concat(options.on)

    vim.cmd(table.concat({ 'autocmd', on, pattern, utils.wrapFunction('aucmd', listener) }, ' '))
    return
  end

  vim.api.nvim_create_autocmd(options.on, {
    group = options.group,
    pattern = options.pattern,
    [type(listener) == 'function' and 'callback' or 'command'] = listener,
  })
end

function l.try_concat(entries)
  if type(entries) == 'table' then
    return table.concat(entries, ',')
  end

  if type(entries) == 'string' then
    return entries
  end

  return nil
end

return M
