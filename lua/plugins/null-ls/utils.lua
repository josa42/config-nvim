local utils = require('null-ls.utils')
local cache = require('config.utils.cache')

local M = {}

local function path_join(...)
  local path = utils.path.join(...)
  return path
end

local eslintrc_root =
  utils.root_pattern('.eslintrc', 'eslintrc.json', '.eslintrc.cjs', '.eslintrc.js', 'eslintrc.yaml', 'eslintrc.yml')

local not_home = function(fn)
  local home = os.getenv('HOME')
  return function(bufname)
    local dir = fn(bufname)
    if dir == home then
      return nil
    end
    return dir
  end
end

local yarn_root = not_home(utils.root_pattern('.yarn'))
local pkg_root = not_home(utils.root_pattern('package.json'))

M.eslint_root = function(p)
  local bufname = p and p.bufname or vim.api.nvim_buf_get_name(0)
  return eslintrc_root(bufname) or yarn_root(bufname) or pkg_root(bufname)
end

local has_file = function(root, name)
  return (root ~= nil and name ~= nil) and utils.path.exists(path_join(root, name))
end

local npm_bin_dir = cache.fn('npm_bin_dir', function(p)
  local root = M.eslint_root(p)

  -- TODO npm bin has been removed in npm 9
  local out = vim.trim(vim.fn.system('cd ' .. vim.fn.shellescape(root) .. '; npm bin'))

  if utils.path.exists(out) then
    return path_join(root, 'node_modules', '.bin')
  end

  return nil
end)

local find_in_dir = cache.fn('find_in_dir', function(dir, name)
  if has_file(dir, name) then
    return path_join(dir, name)
  end

  return nil
end)

local find_bin_using_npm_query = cache.fn('find_bin_using_npm_query', function(dir, name)
  local ok, res = pcall(function()
    local cmd = ('cd %s; npm query \\#%s'):format(vim.fn.shellescape(dir, name))
    local eslint = vim.json.decode(vim.fn.system(cmd))
    if eslint and eslint[1] ~= nil then
      return path_join(eslint[1].path, eslint[1].bin.eslint)
    end
  end)

  if ok then
    return res
  end

  return nil
end)

local find_in_repo = cache.fn('find_in_repo', function(dir, rel_path)
  if not dir or not rel_path then
    return nil
  end

  local home = os.getenv('HOME')

  while true do
    for _, p in ipairs(vim.fn.glob(path_join(dir, rel_path), true, true)) do
      if utils.path.exists(p) then
        return p
      end
    end

    if utils.path.exists(path_join(dir, '.git')) or vim.tbl_contains({ home, '/', '.' }, dir) then
      return nil
    end

    dir = vim.fs.dirname(dir)
  end
end)

local find_local_bin = cache.fn('find_local_bin', function(p, name)
  local checkers = {
    function()
      return find_in_dir(npm_bin_dir(p), name)
    end,
    function()
      return find_bin_using_npm_query(pkg_root(p.bufname), name)
    end,
    function()
      if name == 'eslint' then
        return find_in_dir(path_join(M.eslint_root(p), 'node_modules', '.bin'), name)
      end
    end,
    function()
      return find_in_repo(vim.fs.dirname(p.bufname), path_join('node_modules', '.bin', name))
    end,
  }

  for _, fn in ipairs(checkers) do
    local bin = fn()
    if bin ~= nil then
      return bin
    end
  end

  return nil
end)

function M.condition_eslint_without_json(p)
  local root = M.eslint_root(p)
  return not has_file(root, 'node_modules/jsonc-eslint-parser/package.json') and find_local_bin(p, 'eslint') ~= nil
end

function M.condition_eslint_with_json(p)
  local root = M.eslint_root(p)
  return has_file(root, 'node_modules/jsonc-eslint-parser/package.json') and find_local_bin(p, 'eslint') ~= nil
end

function M.condition_not_eslint_with_json(p)
  return not M.condition_eslint_with_json(p)
end

function M.condition_prettier_markdown(p)
  return os.getenv('NVIMV_ENABLE_PRETTIER_MARKDOWN') == '1' and has_file(M.eslint_root(p), 'node_modules/.bin/prettier')
end

return M
