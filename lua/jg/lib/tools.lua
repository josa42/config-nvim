local M = {}

local home = os.getenv('HOME')
local dataDir = os.getenv('XDG_DATA_HOME') or home .. '/.local/share'
local toolsDir = dataDir .. '/nvim/tools'

local npmDir = toolsDir .. '/npm'
local npmBin = npmDir .. '/node_modules/.bin'
local goDir = toolsDir .. '/go'
local goBin = goDir .. '/bin'
local pipDir = toolsDir .. '/pip'
local pipBin = pipDir .. '/bin'

function appendEnv(name, env)
  vim.cmd('let $' .. name .. '.=":' .. vim.fn.escape(table.concat(env, ':'), '"') .. '"')
end

appendEnv('PATH', { npmBin, goBin, pipBin })
appendEnv('PYTHONPATH', { pipDir })

function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local npm = {}
function npm.install(tool, recipe)
  local pkg = recipe.pkg or tool

  vim.fn.system('mkdir -p ' .. npmDir)
  vim.fn.system(
    'cd ' .. npmDir .. ' && ls package.json > /dev/null 2> /dev/null || ' .. 'npm init -y  > /dev/null 2> /dev/null'
  )
  vim.fn.system('cd ' .. npmDir .. ' && ' .. 'npm install ' .. pkg .. ' > /dev/null 2> /dev/null')
end
function npm.path(tool, recipe)
  return npmDir .. '/node_modules/.bin/' .. tool
end

local go = {}
function go.install(tool, recipe)
  vim.fn.system('env GO111MODULE=on GOPATH=' .. goDir .. ' GOBIN=' .. goDir .. '/bin go get -u ' .. recipe.pkg)
end
function go.path(tool, recipe)
  return goDir .. '/bin/' .. tool
end

local pip = {}
function pip.install(tool, recipe)
  local pkg = recipe.pkg or tool
  vim.fn.system('pip3 install --ignore-installed --target=' .. pipDir .. ' ' .. pkg)
end
function pip.path(tool, recipe)
  return pipDir .. '/bin/' .. tool
end

local recipes = {
  autopep8 = { installer = pip },
  fixjson = { installer = npm },
  luafmt = { installer = npm, pkg = 'lua-fmt' },
  prettier = { installer = npm },
  shfmt = { installer = go, pkg = 'mvdan.cc/sh/cmd/shfmt' },
}

function M.install(tool, force)
  local recipe = recipes[tool]
  if recipe == nil then
    print('[error] No recipe found for ' .. tool)
    return
  end

  local i = recipe.installer
  if force or not file_exists(i.path(tool, recipe)) then
    print('installing: ' .. tool)
    i.install(tool, recipe)
    print('installed: ' .. tool)
  end
end

function M.path(tool)
  local recipe = recipes[tool]
  if recipe == nil then
    return tool
  end

  local i = recipe.installer

  return i.path(tool, recipe)
end

return M
