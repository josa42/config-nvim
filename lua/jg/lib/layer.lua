local plug = require('jg.lib.plug')

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
    for _,map_args in ipairs(opts.map) do
      vim.api.nvim_set_keymap(map_args[1], map_args[2], map_args[3], map_args[4] or l.defaultMapOpts(map_args[3]))
    end
  end
end

function M.load()
    plug.run()
end

function l.defaultMapOpts(cmd)
  local noremap = string.sub(cmd, 1, string.len("<Plug>")) ~= "<Plug>"
  return { noremap=noremap, silent=true }
end

return M
