local paths = require('jg.lib.paths')

local plugDir = paths.dataDir .. '/plugged'
local plugFile = paths.dataDir .. '/site/autoload/plug.vim'
local plugURL = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

local M = {}
local plugins = {}


function M.use(opts)
  for _, plugin in ipairs(opts.require or {}) do
    M.require(plugin)
  end

  if opts.before ~= nil then
    M.before(opts.before)
  end

  if opts.after ~= nil then
    M.after(opts.after)
  end
end

function M.require(...)
  for _, plugin in ipairs({ ... }) do
    if type(plugin) == 'string' then
      table.insert(plugins, { name = plugin })
    elseif vim.tbl_islist(plugin) then
      table.insert(plugins, { name = plugin[1], options = plugin[2] })
    end
  end

  return M
end

function M.before(handler)
  table.insert(plugins, { before = handler })
end

function M.after(handler)
  table.insert(plugins, { after = handler })
end

function M.register(...)
  for _, plugin in ipairs({ ... }) do
    table.insert(plugins, plugin)
  end
end

local function exists(path)
  return vim.fn.empty(vim.fn.glob(path)) == 0
end

local function startsWith(str, prefix)
  return string.sub(str,1,string.len(prefix)) == prefix
end

local function hasMissingPlugs()
  for _,p in pairs(vim.g.plugs) do
    if type(p) ~= 'table' or startsWith(p.dir, plugDir) and not exists(p.dir) then
      return true
    end
  end
  return false
end

local function plugInstall()
  vim.cmd('PlugInstall --sync')
end

local function install()
  if not exists(plugFile) then
    vim.cmd('silent !curl -fLo ' .. plugFile .. ' --create-dirs ' .. plugURL)
  end
end

local function add(name, options)
  vim.fn['plug#'](name, options or vim.empty_dict())
end

function M.run()
  for _, plugin in pairs(plugins) do
    if plugin.before then
      plugin.before()
    end
  end

  install()
  vim.call('plug#begin', plugDir)
  for _, plugin in pairs(plugins) do
    if plugin.name ~= nil then
      add(plugin.name, plugin.options)
    end
  end
  vim.call('plug#end')
  if hasMissingPlugs() then plugInstall() end

  for _, plugin in pairs(plugins) do
    if plugin.after then
      plugin.after()
    end
  end
end


return M

