local M = {}
local l = {}
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

-- local data_dir = '/tmp/lazy'
local data_dir = vim.fn.stdpath('data') .. '/lazy'

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
      local opts = plugin[2] or {}

      if opts.rtp ~= nil then
        opts.config = l.merge_fn(l.config_rtp(plugin[2].rtp), opts.config)
        opts.rtp = nil
      end

      for key, value in pairs(opts) do
        if vim.tbl_contains(option_keys, key) then
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
  local lazypath = data_dir .. '/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
    -- vim.fn.system({ 'git', '-C', lazypath, 'checkout', 'tags/stable' })
  end
  vim.opt.runtimepath:prepend(lazypath)

  require('lazy').setup(plugins, {
    root = data_dir,
    lockfile = data_dir .. '/lazy-lock.json',
    concurrency = 20,
    checker = {
      enabled = true,
      notify = false,
    },
    change_detection = {
      enabled = false,
    },
    dev = {
      path = '~/github/josa42',
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'netrwPlugin',
          'tohtml',
        },
      },
    },
  })
end

function l.merge_fn(fn1, fn2)
  if fn2 == nil then
    return fn1
  end

  return function(...)
    fn1(...)
    fn2(...)
  end
end

function l.config_rtp(rtp)
  return function(p)
    vim.opt.rtp:append(('%s/%s'):format(p.dir, rtp))
  end
end

return M
