local paths = require('jg.lib.paths')

local plug_dir = paths.data_dir .. '/plugged'
local plug_file = paths.data_dir .. '/site/autoload/plug.vim'
local plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

local plug = vim.fn['plug#']
local plug_begin = vim.fn['plug#begin']
local plug_end = vim.fn['plug#end']

local M = {}
local plugins = {}
local option_keys = {
  'branch',
  'tag',
  'commit',
  'rtp',
  'dir',
  'as',
  'do',
  'on',
  'for',
  'frozen',
}

function M.require(...)
  for _, plugin in ipairs({ ... }) do
    assert(vim.tbl_islist(plugin), 'plugin needs to be a table')
    assert(plugin[1] ~= nil and #plugin[1] > 0, 'plugin name is mandatory')

    local existing = vim.tbl_filter(function(p)
      return p.name == plugin[1]
    end, plugins)[1]

    local options = M.to_options(plugin[2])

    if existing ~= nil then
      existing.options = vim.tbl_extend('force', existing.options or {}, options)
    else
      table.insert(plugins, { name = plugin[1], options = options })
    end
  end

  return M
end

local function exists(path)
  return vim.fn.empty(vim.fn.glob(path)) == 0
end

local function starts_with(str, prefix)
  return string.sub(str, 1, string.len(prefix)) == prefix
end

local function has_missing_plugs()
  for _, p in pairs(vim.g.plugs) do
    if type(p) ~= 'table' or starts_with(p.dir, plug_dir) and not exists(p.dir) then
      return true
    end
  end
  return false
end

local function plug_install()
  vim.cmd.PlugInstall('--sync')
end

function M.run()
  if not exists(plug_file) then
    vim.fn.system(('curl -fLo %s --create-dirs %s'):format(plug_file, plug_url))
  end

  plug_begin(plug_dir)
  for _, plugin in pairs(plugins) do
    plug(plugin.name, plugin.options or vim.empty_dict())
  end
  plug_end()

  if has_missing_plugs() then
    plug_install()
  end
end

function M.to_options(tbl)
  local options = vim.empty_dict()

  if tbl ~= nil then
    for key, value in pairs(tbl) do
      if key == 'dependencies' then
        for _, dep in ipairs(value) do
          if type(dep) == 'string' then
            dep = { dep }
          else
            dep = { dep[1], M.to_options(dep) }
          end
          M.require(dep)
        end
      elseif key == 'build' then
        options['do'] = value
      elseif vim.tbl_contains(option_keys, key) then
        options[key] = value
      elseif type(key) == 'string' then
        vim.notify_once(('Unknown option "%s" for vim-plug'):format(key), vim.log.levels.ERROR)
      end
    end
  end

  return options
end

return M
