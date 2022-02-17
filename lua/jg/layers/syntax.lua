local layer = require('jg.lib.layer')
local au = require('jg.lib.autocmd')
local paths = require('jg.lib.paths')

local filetypes = {
  { '~/.ssh/config*', 'sshconfig' },
  { '~/.ssh/config*', 'sshconfig' },
  { '~/.config/git/*', 'gitconfig' },
  { '*.tmux', 'sh' },
  { '*.conf', 'conf' },
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
  { '*.jsx', 'javascript' },
}

layer.use({
  requires = {
    -- 'sheerun/vim-polyglot',
    'zhaozg/vim-diagram',
    'rhysd/vim-syntax-codeowners',
    'darfink/vim-plist',
    'josa42/vim-monkey-c',

    -- test
    'mityu/vim-applescript',
    'bfontaine/Brewfile.vim',
    'mustache/vim-mustache-handlebars',
    'mityu/vim-applescript',
  },

  init = function()
    vim.g.polyglot_disabled = { 'sensible', 'vim-sleuth', 'autoindent' }

    au.group('jg.layers.syntax.detect', function(cmd)
      for _, ft in ipairs(filetypes) do
        local pattern = string.gsub(ft[1], '^~', paths.home)
        local filetype = ft[2]

        cmd({ on = { 'BufNewFile', 'BufRead' }, pattern = pattern }, function()
          vim.bo.filetype = filetype
        end)
      end
    end)
  end,
})
