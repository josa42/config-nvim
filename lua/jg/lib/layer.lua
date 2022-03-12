require('jg.lib.polyfills')

local plug = require('jg.lib.plug')

local M = {}
local l = {}

l.init_handlers = {}
l.setup_handlers = {}

l.layer_names = {}

function M.use(opts)
  if opts.enabled == false then
    return
  end

  opts.name = opts.name or l.default_name()

  assert(not vim.tbl_contains(l.layer_names, opts.name), ('layer.name must be unique: %s'):format(opts.name))
  table.insert(l.layer_names, opts.name)

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

    -- autocmds = {
    --   {
    --     { 'BufEnter' }, callback = function()
    --       print('entering a buffer')
    --     end,
    --   },
    -- },
    l.apply_autocmds(('layer:%s'):format(opts.name), l.try_call(opts.autocmds))

    -- commands = {
    --   Foo1 = 'echo "Foo"',
    --   Foo2 = { 'echo "Foo"', nargs = 0 },
    --   Foo3 = function() print('Foo') end,
    -- }
    l.apply_commands(l.try_call(opts.commands))
  end)
end

function M.load()
  l.run_handlers(l.init_handlers)
  plug.run()
  l.run_handlers(l.setup_handlers)
end

function l.default_name()
  local i = debug.getinfo(3)
  return ('%s:%d'):format(i.short_src:gsub('^.*%/layers%/', ''):gsub('%.lua$', ''), i.currentline)
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

function l.to_dict(tbl)
  local dict = {}
  for k, v in pairs(tbl) do
    if type(k) == 'string' then
      dict[k] = v
    end
  end

  return dict
end

function l.to_list(tbl)
  local list = {}
  for _, v in ipairs(tbl) do
    table.insert(list, v)
  end

  return list
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

function l.apply_autocmds(group_name, autocmds)
  if autocmds ~= nil then
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })

    for _, autocmd in ipairs(autocmds) do
      vim.api.nvim_create_autocmd(autocmd[1], l.to_dict(autocmd))
    end
  end
end

function l.apply_commands(commands)
  for name, cmd in pairs(commands or {}) do
    if type(cmd) == 'function' or type(cmd) == 'string' then
      cmd = { cmd }
    end
    assert(type(cmd[1]) == 'function' or type(cmd[1]) == 'string')

    vim.api.nvim_add_user_command(name, cmd[1], l.to_dict(cmd))
  end
end

return M
