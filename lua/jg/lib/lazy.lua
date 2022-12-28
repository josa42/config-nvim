local M = {}
local plugins = {}
local option_keys = {
  'dir',
  'url',
  'name',
  'dev',
  'lazy',
  'enabled',
  'cond',
  'dependencies',
  'init',
  'config',
  'build',
  'branch',
  'tag',
  'commit',
  'version',
  'pin',
  'event',
  'cmd',
  'ft',
  'keys',
  'module',
  'priority',
}
function M.require(...)
  for _, plugin in ipairs({ ... }) do
    assert(vim.tbl_islist(plugin), 'plugin needs to be a table')
    assert(plugin[1] ~= nil and #plugin[1] > 0, 'plugin name is mandatory')

    local existing = vim.tbl_filter(function(p)
      return p.name == plugin[1]
    end, plugins)[1]

    if existing ~= nil then
      vim.notify_once(('plugin "%s" is required twice'):format(plugin[1]), vim.log.levels.ERROR)
    else
      local spec = { plugin[1] }

      for key, value in pairs(plugin[2] or {}) do
        if key == 'do' then
          spec.build = value
        elseif key == 'rtp' then
          spec.config = function(p)
            vim.opt.rtp:append(p.dir .. '/' .. plugin[2].rtp)
          end
        elseif vim.tbl_contains(option_keys, key) then
          spec[key] = value
        else
          vim.notify_once(('[%s] Unknown option for lazy.nvim'):format(plugin[1], key), vim.log.levels.ERROR)
        end
      end
      table.insert(plugins, spec)
    end
  end

  return M
end

function M.run()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      'https://github.com/folke/lazy.nvim.git',
      lazypath,
    })
  end
  vim.opt.runtimepath:prepend(lazypath)

  require('lazy').setup(plugins, {
    lockfile = vim.fn.stdpath('data') .. '/lazy/lazy-lock.json',
    checker = {
      enabled = true,
    },
    dev = {
      path = '~/github/josa42',
    },
  })
end

return M
