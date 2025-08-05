vim.filetype.add({
  extension = {
    conf = 'conf',
    template = 'html',
    mc = 'monkeyc',
  },
  filename = {
    ['Vagrantfile'] = 'ruby',
    ['.eslintrc'] = 'json',
    ['Brewfile'] = 'ruby',
    ['Dockerfile.*'] = 'dockerfile',
    ['.parcelrc'] = 'json',
    ['.terserrc'] = 'json',
    ['.stylelintrc'] = 'json',
    ['api-extractor.json'] = 'jsonc',
  },
  pattern = {
    ['~/.ssh/config.*'] = 'sshconfig',
    ['~/.config/git/hooks/.*'] = 'sh',
    ['~/.config/git/.*'] = 'gitconfig',
    ['~/.config/direnv/direnvrc'] = 'sh',
    ['~/.direnvrc'] = 'sh',
    ['~/.config/kitty/.*.conf'] = 'kitty',
  },
})
