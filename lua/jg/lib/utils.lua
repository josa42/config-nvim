local M = {}

-- Source https://gist.github.com/haggen/2fd643ea9a261fea2094

local charset = {}
for i = 48, 57 do
  table.insert(charset, string.char(i))
end
for i = 65, 90 do
  table.insert(charset, string.char(i))
end
for i = 97, 122 do
  table.insert(charset, string.char(i))
end

function M.randomString(length)
  if length == nil then
    length = 16
  end
  if length <= 0 then
    return ''
  end

  math.randomseed(os.clock() ^ 5)
  return M.randomString(length - 1) .. charset[math.random(1, #charset)]
end

function M.contains(list, value)
  for i, ivalue in ipairs(list) do
    if ivalue == value then
      return true
    end
  end
  return false
end

function M.wrapFunction(name, cmd)
  if type(cmd) ~= 'string' then
    local fname = '__wrapper_' .. name .. '_' .. M.randomString(16)
    _G[fname] = cmd

    cmd = 'lua ' .. fname .. '()'
  end
  return cmd
end

return M
