local plug = require('jg.lib.plug')
local utils = require('jg.lib.utils')

local M = {}
local l = {}

function M.use(opts)
  if opts.enabled == false then
    return
  end

  for _, plugin in ipairs(opts.requires or {}) do
    plug.require(plugin)
  end

  if opts.init ~= nil then
    plug.before(opts.init)
  end

  if opts.setup ~= nil then
    plug.after(opts.setup)
  end

  if opts.map ~= nil then
    plug.after(function()
      if type(opts.map) == 'function' then
        plug.after(function()
          l.applyKeyMaps(opts.map())
        end)
      else
        l.applyKeyMaps(opts.map)
      end
    end)
  end
end

function M.load()
  plug.run()
end

function l.applyKeyMaps(maps)
  for _, map in ipairs(maps) do
    local mode = map[1]
    local lhs = map[2]
    local rhs = map[3]
    local opts = map[4] or { silent = true }

    assert(rhs ~= nil, map[5])

    vim.keymap.set(mode, lhs, rhs, opts)

    local label = map[5]
    if label ~= nil then
      require('cheatsheet').add_cheat(label, '[' .. mode .. '] ' .. lhs, 'keymap')
    end
  end
end

return M
