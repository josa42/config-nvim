local M = {}

function M.file_exists(file)
  local f = io.open(file, 'rb')
  if f then
    f:close()
  end
  return f ~= nil
end

function M.read(path)
  -- return io.lines(path):concat('\n')
  local file = io.open(path, 'r')
  io.input(file)
  return io.read('*a')
end

function M.read_json(path)
  local content = M.read(path)
  if content ~= nil then
    return vim.fn.json_decode(content)
  end
end

function M.binExist(...)
  for _, bin in ipairs({ ... }) do
    if vim.fn.executable(bin) ~= 1 then
      return false
    end
  end
  return true
end

return M
