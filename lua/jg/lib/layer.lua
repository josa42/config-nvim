local plug = require('jg.lib.plug')
local utils = require('jg.lib.utils')

local M = {}
local l = {}

function M.use(opts)
  for _, plugin in ipairs(opts.require or {}) do
    plug.require(plugin)
  end

  if opts.before ~= nil then
    plug.before(opts.before)
  end

  if opts.after ~= nil then
    plug.after(opts.after)
  end

  if opts.map ~= nil then
    if type(opts.map) == 'function' then
      plug.after(function()
        l.applyKeyMaps(opts.map())
      end)
    else
      l.applyKeyMaps(opts.map)
    end
  end
end

function M.load()
  plug.run()
end

function l.applyKeyMaps(maps)
  for _, map in ipairs(maps) do
    local mode = map[1]
    local keymap = map[2]
    local cmd = map[3]
    if type(cmd) == 'function' then
      cmd = '<cmd>' .. utils.wrapFunction('keymap', cmd) .. '<cr>'
    end
    local map_opts = map[4]

    assert(cmd ~= nil, 'cmd must be set to set a key map')

    vim.api.nvim_set_keymap(mode, keymap, cmd, map_opts or l.defaultMapOpts(cmd))
  end
end

function l.defaultMapOpts(cmd)
  if cmd ~= nil then
    local noremap = string.sub(cmd, 1, string.len('<Plug>')) ~= '<Plug>'
    return { noremap = noremap, silent = true }
  end

  return {}
end

return M
