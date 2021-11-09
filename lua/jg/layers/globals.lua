function flag(name, options, default)
  local value = os.getenv(name) or default
  if vim.fn.index(options, value) == -1 then
    print('[error] ' .. name .. ' has to be one of: [' .. table.concat(options, ', ') .. ']')
    return default
  end
  return value
end

_G.__flags = {
  treesitter = flag('NVIM_TS', { 'true', 'false' }, 'false'),
  fuzzy_finder = flag('NVIM_FUZZY_FINDER', { 'fzf', 'fzf-lua', 'telescope' }, 'telescope'),
  snippets = flag('NVIM_SNIPPETS', { 'vsnip' }, 'vsnip'),
  tree = flag('NVIM_TREE', { 'nvim-tree', 'nvim-filetree' }, 'nvim-filetree'),
}

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
  format_buffer = '<leader>f',
}

_G.__icons = {
  action = '',
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
