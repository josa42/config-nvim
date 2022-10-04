vim.g.do_filetype_lua = 1

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
  },
  pattern = {
    ['~/.ssh/config.*'] = 'sshconfig',
    ['~/.config/git/hooks/.*'] = 'sh',
    ['~/.config/git/.*'] = 'gitconfig',
    ['~/.config/direnv/direnvrc'] = 'sh',
    ['~/.direnvrc'] = 'sh',
  },
})
