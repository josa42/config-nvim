local command = require('jg.lib.command')
local paths = require('jg.lib.paths')
local layer = require('jg.lib.layer')

layer.use({
  requires = {
    {
      'euclio/vim-markdown-composer',
      {
        ['do'] = function(info)
          print('do')
          if info.status ~= 'unchanged' or info.force then
            vim.fn.system('cargo build --release --locked')
          end
        end,
      },
    },
  },

  init = function()
    vim.g.markdown_composer_custom_css = {
      'file://' .. paths.configDir .. '/files/euclio--vim-markdown-composer.css',
    }
    vim.g.markdown_composer_syntax_theme = 'Atom One Dark'
    vim.g.markdown_composer_open_browser = 0

    command.define('MarkdownPreview', { nargs = 0 }, 'ComposerOpen')
  end,
})
