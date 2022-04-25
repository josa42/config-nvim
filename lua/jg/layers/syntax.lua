local layer = require('jg.lib.layer')
local paths = require('jg.lib.paths')

local filetypes = {
  { '~/.ssh/config*', 'sshconfig' },
  { '~/.ssh/config*', 'sshconfig' },
  { '~/.config/git/*', 'gitconfig' },
  { '~/.config/git/hooks/*', 'sh' },
  { '*.tmux', 'sh' },
  { '*.conf', 'conf' },
  { '.tmux.conf', 'tmux' },
  { 'Vagrantfile', 'ruby' },
  { '.eslintrc', 'json' },
  { '*/inventory/*.yml', 'yaml.ansible' },
  { '*/playbooks/*.yml', 'yaml.ansible' },
  { 'Brewfile', 'ruby' },
  { 'Dockerfile.*', 'dockerfile' },
  { '*.template', 'mustache' },
  { 'go.mod', 'gomod' },
  { '$HOME/.config/direnv/direnvrc', 'sh' },
  { '$HOME/.direnvrc', 'sh' },
  { '.parcelrc', 'json' },
  { '.terserrc', 'json' },
  { '.stylelintrc', 'json' },
}

-- See: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local ts_enable = 'all'

-- See: https://github.com/sheerun/vim-polyglot#language-packs
local polyglot_disable = { -- <= handled by treesitter
  'css',
  'go',
  'gomod',
  'gowork',
  'html',
  'java',
  'javascript',
  'json',
  'json5',
  'jsonc',
  'php',
  'sh',
  'typescript',
  'yaml',
  'python',
}

layer.use({
  enabled = true,
  name = 'syntax-treesitter',

  requires = {
    { 'nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' } },
  },
  setup = function()
    local configs = require('nvim-treesitter.configs')

    configs.setup({
      ensure_installed = ts_enable,
      ignore_install = { 'phpdoc' },
      highlight = { enable = true },
      indent = { enable = false },
      autotag = { enable = false },
    })
  end,
})

layer.use({
  name = 'syntax',

  requires = {
    'sheerun/vim-polyglot',
    -- 'josa42/vim-polyglot',
    'zhaozg/vim-diagram',
    'rhysd/vim-syntax-codeowners',
    'darfink/vim-plist',
    'josa42/vim-monkey-c',
  },

  init = function()
    vim.g.polyglot_disabled = vim.tbl_flatten({ { 'sensible', 'vim-sleuth', 'autoindent' }, polyglot_disable })
  end,

  autocmds = function()
    return vim.tbl_map(function(ft)
      local pattern = string.gsub(ft[1], '^~', paths.home)
      local filetype = ft[2]

      return {
        { 'BufNewFile', 'BufRead' },
        pattern = pattern,
        callback = function()
          vim.bo.filetype = filetype
        end,
      }
    end, filetypes)
  end,
})

-- golang
layer.use({
  enabled = not vim.tbl_contains(polyglot_disable, 'go'),

  init = function()
    vim.g.go_highlight_array_whitespace_error = true
    vim.g.go_highlight_build_constraints = true
    vim.g.go_highlight_chan_whitespace_error = true
    vim.g.go_highlight_debug = true
    vim.g.go_highlight_extra_types = true
    vim.g.go_highlight_fields = true
    vim.g.go_highlight_format_strings = true
    vim.g.go_highlight_function_calls = true
    vim.g.go_highlight_function_parameters = true
    vim.g.go_highlight_functions = true
    vim.g.go_highlight_generate_tags = true
    vim.g.go_highlight_operators = true
    vim.g.go_highlight_space_tab_error = true
    vim.g.go_highlight_string_spellcheck = true
    vim.g.go_highlight_trailing_whitespace_error = true
    vim.g.go_highlight_types = true
    vim.g.go_highlight_variable_assignments = true
    vim.g.go_highlight_variable_declarations = true
  end,
})

-- yaml
layer.use({
  enabled = not vim.tbl_contains(polyglot_disable, 'python'),

  init = function()
    vim.g.yaml_schema = 'pyyaml'
  end,
})

-- markdown
layer.use({
  enabled = not vim.tbl_contains(polyglot_disable, 'markdown'),

  init = function()
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

-- ansible
layer.use({
  enabled = not vim.tbl_contains(polyglot_disable, 'ansible'),

  init = function()
    vim.g.ansible_unindent_after_newline = 1
  end,
})
