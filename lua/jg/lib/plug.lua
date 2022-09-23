local paths = require('jg.lib.paths')

local plugDir = paths.data_dir .. '/plugged'
local plugFile = paths.data_dir .. '/site/autoload/plug.vim'
local plugURL = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

local plug = vim.fn['plug#']
local plug_begin = vim.fn['plug#begin']
local plug_end = vim.fn['plug#end']

local M = {}
local plugins = {}

function M.require(...)
  for _, plugin in ipairs({ ... }) do
    assert(vim.tbl_islist(plugin), 'plugin needs to be a table')
    assert(plugin[1] ~= nil and #plugin[1] > 0, 'plugin name is mandatory')

    local existing = vim.tbl_filter(function(p)
      return p.name == plugin[1]
    end, plugins)[1]

    if existing ~= nil then
      if plugin[2] ~= nil then
        existing.options = vim.tbl_extend('force', existing.options or {}, plugin[2])
      end
    else
      table.insert(plugins, { name = plugin[1], options = plugin[2] })
    end
  end

  return M
end

local function exists(path)
  return vim.fn.empty(vim.fn.glob(path)) == 0
end

local function startsWith(str, prefix)
  return string.sub(str, 1, string.len(prefix)) == prefix
end

local function has_missing_plugs()
  for _, p in pairs(vim.g.plugs) do
    if type(p) ~= 'table' or startsWith(p.dir, plugDir) and not exists(p.dir) then
      return true
    end
  end
  return false
end

local function plug_install()
  vim.cmd('PlugInstall --sync')
end

function M.run()
  if not exists(plugFile) then
    vim.cmd(('silent !curl -fLo %s --create-dirs %s'):format(plugFile, plugURL))
  end

  plug_begin(plugDir)
  for _, plugin in pairs(plugins) do
    plug(plugin.name, plugin.options or vim.empty_dict())
  end
  plug_end()

  if has_missing_plugs() then
    plug_install()
  end
end

return M
