local layer = require('jg.lib.layer')

layer.use({
  enabled = true,
  require = {
    { 'nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' } },
    { 'nvim-treesitter/playground' },
  },

  after = function()
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.monkeyc = {
      install_info = {
        url = "~/github/josa42/tree-sitter-monkeyc", -- local path or git repo
        files = { 'src/parser.c' }
      },
      filetype = 'monkeyc'
    }

    require('nvim-treesitter.configs').setup({
      ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      playground = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- highlight = { enable = { 'monkeyc' } },
      indent = { enable = false },
      autotag = { enable = false },
    })
  end,
})
