local M = {}

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

function M.eslint_bin(file)
  local eslint = vim.fs.find('node_modules/.bin/eslint', {
    upward = true,
    path = M.root_eslintrc(file),
    stop = vim.fs.dirname(M.root({ 'package-lock.json' }, file)),
  })[1]

  return eslint ~= nil
end

function M.prettier_bin(file)
  return has_file(M.root_npm(file), 'node_modules/.bin/prettier')
end

function M.eslint_json_parser(file)
  return has_file(M.root_eslintrc(file), 'node_modules/jsonc-eslint-parser/package.json')
end

return M
