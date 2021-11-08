local layer = require('jg.lib.layer')

local cmd = require('jg.lib.command')
local open = require('jg.lib.open')

layer.use {
  require = {
    'editorconfig/editorconfig-vim',
    'josa42/nvim-project-config',
  },

  after = function()
    local p = require('jg.project-config')

    cmd.define('Config', { bar = true, nargs = 0 }, 'silent! tabe $MYVIMRC')

    cmd.define('ProjectConfig', {}, function()
      local config = p.find_config({ p.local_config, p.global_config })
      if config then
        open.edit('tabe', config)
      end
    end)

    cmd.define('ProjectConfigMove', {}, function()
      local config = p.find_config({ p.local_config })
      if config then
        local dir = config:gsub('/.vim/init.vim$', ''):gsub('/.vim/init.lua$', '')
        local gdir = p.global_config(dir)

        vim.fn.system('mv ' .. dir .. '/.vim ' .. gdir)

        vim.cmd [[ ProjectConfig ]]
      end
    end)
  end,
}



