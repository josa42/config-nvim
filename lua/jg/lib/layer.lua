local plug = require('jg.lib.plug')

local M = {}
local l = {}

l.init_handlers = {}
l.setup_handlers = {}

function M.use(opts)
  if opts.enabled == false then
    return
  end

  for _, plugin in ipairs(opts.requires or {}) do
    if type(plugin) == 'string' then
      plugin = { plugin }
    end
    plug.require(plugin)
  end

  if type(opts.init) == 'function' then
    table.insert(l.init_handlers, opts.init)
  end

  if type(opts.setup) == 'function' then
    table.insert(l.setup_handlers, opts.setup)
  end

  table.insert(l.setup_handlers, function()
    l.apply_key_maps(l.try_call(opts.map))
  end)
end

function M.load()
  l.run_handlers(l.init_handlers)
  plug.run()
  l.run_handlers(l.setup_handlers)
end

function l.run_handlers(handers)
  for _, hander in pairs(handers) do
    hander()
  end
end

function l.try_call(fn)
  if type(fn) == 'function' then
    return fn()
  end

  return fn
end

function l.apply_key_maps(maps)
  for _, map in ipairs(maps or {}) do
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
