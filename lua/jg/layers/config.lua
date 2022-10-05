local layer = require('jg.lib.layer')
local open = require('jg.lib.open')

layer.use({
  requires = {
    'editorconfig/editorconfig-vim',
    'josa42/nvim-project-config',
  },

  commands = {
    Config = { 'silent! tabe $MYVIMRC', bar = true, nargs = 0 },
    ProjectConfig = function()
      local p = require('jg.project-config')
      local config = p.find_config({ p.local_config, p.global_config })
      if config then
        open.edit('tabe', config)
      end
    end,
    ProjectConfigMove = function()
      local p = require('jg.project-config')
      local config = p.find_config({ p.local_config })
      if config then
        local dir = config:gsub('/.vim/init.vim$', ''):gsub('/.vim/init.lua$', '')
        local gdir = p.global_config(dir)

        vim.fn.system('mv ' .. dir .. '/.vim ' .. gdir)

        vim.cmd.ProjectConfig()
      end
    end,
  },
})
