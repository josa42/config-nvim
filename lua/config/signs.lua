local signs = {
  action = '',
  vcs = {
    add = '│', -- '✚'
    change = '│', -- '✚'
    change_delete = '│', -- '✚'
    delete_top = '_',
    delete = '‾',
  },
  diagnostic = {
    error = '●',
    warning = '⦿',
    info = '◎',
    hint = '○',
    debug = '○',
    trace = '○',
    -- error = '',
    -- warning = '',
    -- info = '',
    -- hint = '',
    -- debug = '',
    -- trace = '✎',
  },
  fs = {
    file = '󰈔',
    dir = '󰉋',
    dir_open = '󰈔',
  },
}

signs.trouble = {
  error = signs.diagnostic.error,
  warning = signs.diagnostic.warning,
  hint = signs.diagnostic.hint,
  information = signs.diagnostic.info,
}

signs.notify = {
  ERROR = signs.diagnostic.error,
  WARN = signs.diagnostic.warning,
  INFO = signs.diagnostic.info,
  DEBUG = signs.diagnostic.debug,
  TRACE = signs.diagnostic.trace,
}

signs.gitsigns = {
  add = { text = '│' },
  change = { text = '│' },
  delete = { text = '_' },
  topdelete = { text = '‾' },
  changedelete = { text = '~' },
  untracked = { text = '┊' },
}

return signs
