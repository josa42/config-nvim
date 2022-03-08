local utils = require('jg.lib.utils')

local l = {}

if type(vim.api.nvim_create_augroup) ~= 'function' then
  vim.api.nvim_create_augroup = function(name, opts)
    opts = opts or {}

    vim.cmd('augroup ' .. name)
    if opts.clear == nil or opts.clear then
      vim.cmd('autocmd!')
    end
    vim.cmd('augroup end')

    return name
  end
end

if type(vim.api.nvim_create_autocmd) ~= 'function' then
  vim.api.nvim_create_autocmd = function(event, opts)
    opts = opts or {}

    if opts.callback ~= nil and opts.command ~= nil then
      return print('error: Callback cannot be used with')
    end

    local command = opts.command
    if type(opts.callback) == 'function' then
      command = utils.wrapFunction('aucmd', opts.callback)
    elseif type(opts.callback) == 'string' then
      command = 'call ' .. opts.callback .. '()'
    elseif opts.callback ~= nil then
      return print('error: Invalid callback type: ' .. type(opts.callback))
    end

    local pattern = l.try_concat(opts.pattern) or '*'
    local on = l.try_concat(event)

    if opts.group ~= nil then
      vim.cmd('augroup ' .. opts.group)
    end
    vim.cmd(table.concat({ 'autocmd', on, pattern, command }, ' '))
    if opts.group ~= nil then
      vim.cmd('augroup end')
    end
  end
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
