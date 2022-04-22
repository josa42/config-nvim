local paths = require('jg.lib.paths')

-- local plugDir = paths.dataDir .. '/plugged'
local packerDir = paths.dataDir .. '/site/pack/packer/start/packer.nvim'
local packerURL = 'https://github.com/wbthomason/packer.nvim'

-- local plug = vim.fn['plug#']
-- local plug_begin = vim.fn['plug#begin']
-- local plug_end = vim.fn['plug#end']
--
local M = {}
local plugins = {}
--
function M.require(...)
  for _, plugin in ipairs({ ... }) do
    assert(vim.tbl_islist(plugin), 'plugin needs to be a table or string')
    assert(plugin[1] ~= nil and #plugin[1] > 0, 'plugin name is mandatory')

    table.insert(plugins, vim.tbl_extend('error', { plugin[1] }, plugin[2] or {}))
  end

  return M
end

local function exists(path)
  return vim.fn.empty(vim.fn.glob(path)) == 0
end
--
-- local function startsWith(str, prefix)
--   return string.sub(str, 1, string.len(prefix)) == prefix
-- end
--
-- local function has_missing_plugs()
--   for _, p in pairs(vim.g.plugs) do
--     if type(p) ~= 'table' or startsWith(p.dir, plugDir) and not exists(p.dir) then
--       return true
--     end
--   end
--   return false
-- end
--
-- local function plug_install()
--   vim.cmd('PlugInstall --sync')
-- end

function M.run()
  local bootstraped = false

  if not exists(packerDir) then
    bootstraped = vim.fn.system({ 'git', 'clone', '--depth', '1', packerURL, packerDir })
  end

  require('packer').startup(function()
    if bootstraped then
      vim.api.nvim_command('packadd packer.nvim')
      require('packer').sync()
    end

    for _, plugin in ipairs(plugins) do
      use(plugin)
    end
  end)

  -- plug_begin(plugDir)
  -- for _, plugin in pairs(plugins) do
  --   plug(plugin.name, plugin.options or vim.empty_dict())
  -- end
  -- plug_end()
  --
  -- if has_missing_plugs() then
  --   plug_install()
  -- end
end

return M
