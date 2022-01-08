local command = require('jg.lib.command')
local paths = require('jg.lib.paths')
local layer = require('jg.lib.plug')

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

    -- plasticboy/vim-markdown (sheerun/vim-polyglot)
    -- -----------------------------------------------------------------------------

    vim.g.vim_markdown_fenced_languages = { 'javascript', 'js=javascript', 'json=javascript', 'bash=sh' }
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_no_default_key_mappings = 1
    vim.g.vim_markdown_folding_disabled = 0
    vim.g.vim_markdown_strikethrough = 1
    vim.g.vim_markdown_edit_url_in = 'tab'
    vim.g.vim_markdown_conceal = 1
    vim.g.vim_markdown_conceal_code_blocks = 0
    vim.g.vim_markdown_no_default_key_mappings = 1

    vim.g.vim_markdown_folding_level = 6
  end,
})
