local M = {}

function M.clear(name)
  if type(name) == 'string' and name ~= '' then
    vim.cmd('highlight clear ' .. name)
  end
end

function M.set(group, color)
  local set = {}
  if color.style then
    table.insert(set, 'gui=' .. color.style)
  end
  if color.fg then
    table.insert(set, 'guifg=' .. color.fg)
  end
  if color.bg then
    table.insert(set, 'guibg=' .. color.bg)
  end
  if color.sp then
    table.insert(set, 'guisp=' .. color.sp)
  end

  vim.cmd('highlight ' .. group .. ' ' .. table.concat(set, ' '))
end

function M.link(fromGroup, toGroup, options)
  options = options or {}

  local cmd = options.force and 'highlight!' or 'highlight'
  local def = options.default or ''

  vim.cmd(cmd .. ' link ' .. def .. ' ' .. fromGroup .. ' ' .. toGroup)
end

return M
