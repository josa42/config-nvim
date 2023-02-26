local paths = require('jg.lib.paths')
local layer = require('jg.lib.layer')

layer.use({
  enabled = false,
  requires = {
    {
      'euclio/vim-markdown-composer',
      build = function(info)
        if info.status ~= 'unchanged' or info.force then
          vim.fn.system('cargo build --release --locked')
        end
      end,
    },
  },

  commands = {
    MarkdownPreview = { 'ComposerOpen', nargs = 0 },
  },

  init = function()
    vim.g.markdown_composer_custom_css = {
      'file://' .. paths.config_dir .. '/files/euclio--vim-markdown-composer.css',
    }
    vim.g.markdown_composer_syntax_theme = 'Atom One Dark'
    vim.g.markdown_composer_open_browser = 0
  end,
})

layer.use({
  enabled = false,
  requires = {
    {
      'iamcco/markdown-preview.nvim',
      build = function()
        vim.fn['mkdp#util#install']()
      end,
    },
  },
})
