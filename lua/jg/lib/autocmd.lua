local M = {}

local utils = require('jg.lib.utils')

-- Usage:
--   au.group('tekkan', function(cmd)
--     cmd({ on = 'BufEnter' }, function()
--       print('wo bist du?')
--     end)
--   end)
function M.group(name, defineCmds)
  if vim.api.nvim_create_augroup == nil then
    vim.cmd('augroup ' .. name)
    vim.cmd('autocmd!')
    defineCmds(M.cmd)
    vim.cmd('augroup end')
    return
  end

  vim.api.nvim_create_augroup(name, { clear = true })
  defineCmds(function(options, listener)
    options.group = name
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
  if options == nil or options.on == nil or listener == nil then
    print('error: Invalid autocmd')
    return
  end

  if type(options) == 'string' then
    options = { on = options }
  end

  if type(listener) ~= 'string' and type(listener) ~= 'function' then
    print('error: Invalid listener type: ' .. type(listener))
    return
  end

  if type(vim.api.nvim_create_autocmd) ~= 'function' then
    if type(options.pattern) ~= 'string' and type(options.pattern) ~= 'table' then
      options.pattern = '*'
    end

    if type(options.pattern) == 'table' then
      options.pattern = table.concat(options.pattern, ',')
    end

    if type(options.on) == 'string' then
      options.on = { options.on }
    end

    local on = table.concat(options.on, ',')
    vim.cmd(table.concat({ 'autocmd', on, options.pattern, utils.wrapFunction('aucmd', listener) }, ' '))
    return
  end

  vim.api.nvim_create_autocmd(options.on, {
    group = options.group,
    pattern = options.pattern,
    [type(listener) == 'function' and 'callback' or 'command'] = listener,
  })
end

return M
