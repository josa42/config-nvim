_G.__keymaps = {
  find_file = '<c-p>',
  find_string = '<c-f>',
  find_config = '<c-c>',
  find_help = '<c-h>',
  trigger_completion = '<c-space>',
  codeaction = '<leader>ac',
  codelens_action = '<leader>al',
  goto_diagnostics_list = 'gll',
  goto_diagnostics_next = 'glj',
  goto_diagnostics_prev = 'glk',
  format_buffer = 'gf',
}

_G.__icons = {
  action = '',
  vcs = {
    add = '│', -- '✚'
    change = '│', -- '✚'
    change_delete = '│', -- '✚'
    delete_top = '_',
    delete = '‾',
  },
  diagnostic = {
    error = '',
    warning = '',
    info = '',
    hint = '',

    --.  16  18  1
  },
}
