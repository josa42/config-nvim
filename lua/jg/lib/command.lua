local M = {}

local utils = require('jg.lib.utils')

function M.define(name, options, cmd)
  local args = {}

  local flags = { 'bang', 'bar', 'buffer' }
  for _,flag in pairs(flags) do
    if options[flag] then
      table.insert(args, '-' .. flag)
    end
  end

  local option_names = { 'nargs', 'complete' }
  for _, option in pairs(option_names) do
    if options[option] then
      table.insert(args, '-' .. option .. '=' .. options[option])
    end
  end

  table.insert(args, name)
  table.insert(args, utils.wrapFunction(name, cmd))

  vim.cmd('command! ' .. table.concat(args, ' '))
end

function M.delete(name)
  vim.cmd('delcommand ' .. name)
end

return M
