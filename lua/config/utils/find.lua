local M = {}

local cache = require('config.utils.cache')

local function exists(file)
  local f = io.open(file, 'r')
  return f ~= nil and io.close(f)
end

local function has_file(dir, file)
  return (dir ~= nil and file ~= nil) and exists(vim.fs.joinpath(dir, file))
end

function M.root(files, file)
  local dirname = vim.fs.dirname(file)
  local found = vim.fs.find(files, { upward = true, path = dirname })[1]
  if found then
    return vim.fs.dirname(found)
  end
end

function M.root_eslintrc(file)
  return M.root(
    { '.eslintrc', 'eslintrc.json', '.eslintrc.cjs', '.eslintrc.js', 'eslintrc.yaml', 'eslintrc.yml' },
    file
  )
end

function M.root_npm(file)
  return M.root({ 'package-lock.json' }, file) or M.root({ 'yarn.lock' }, file) or M.root({ 'package.json' }, file)
end

local find_bin_using_npm_query = cache.fn('config/utils/find:find_bin_using_npm_query', function(dir, name)
  local ok, res = pcall(function()
    local cmd = ('cd %s; npm query \\#%s'):format(vim.fn.shellescape(dir), name)
    local pkg = vim.json.decode(vim.fn.system(cmd))
    if pkg and pkg[1] ~= nil then
      return vim.fs.joinpath(pkg[1].path, pkg[1].bin[name])
    end
  end)

  if ok then
    return res
  end

  return nil
end)

function M.eslint_bin(file)
  local root = M.root_eslintrc(file)
  return has_file(root, 'node_modules/.bin/eslint') or find_bin_using_npm_query(root, 'eslint') ~= nil
end

function M.prettier_bin(file)
  return has_file(M.root_npm(file), 'node_modules/.bin/prettier')
end

function M.eslint_json_parser(file)
  return has_file(M.root_eslintrc(file), 'node_modules/jsonc-eslint-parser/package.json')
end

function M.if_env(name)
  return function()
    local value = os.getenv(name)
    return value == '1' or value == 'true'
  end
end

function M.any(...)
  local fns = { ... }
  return function(self, ctx)
    for _, fn in ipairs(fns) do
      local value = fn(ctx.filename)
      if value then
        return value
      end
    end
  end
end

function M.all(...)
  local fns = { ... }
  return function(self, ctx)
    for _, fn in ipairs(fns) do
      if not fn(ctx.filename) then
        return false
      end
    end
    return true
  end
end

return M
