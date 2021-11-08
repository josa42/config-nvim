if __flags.fuzzy_finder ~= 'fzf' then return end

local plug = require('jg.lib.plug')
local paths = require('jg.lib.paths')
local map = vim.api.nvim_set_keymap

plug.require(
  { 'junegunn/fzf', { ['do'] = vim.fn['fzf#install'] } },
  'junegunn/fzf.vim'
)

-- use fd to find files
vim.cmd('let $FZF_DEFAULT_COMMAND = "fd --type f --hidden --exclude .git --exclude .DS_Store"')


vim.cmd('let $FZF_DEFAULT_OPTS = "' .. vim.fn.join({
  -- prompt on top
  '--layout=reverse',
  '--bind ctrl-a:select-all',
  '--pointer=→ --marker=∙',
  '--preview-window=hidden:noborder',
  -- '--margin=10,10,10,10',
  -- colors
  -- '--color=fg:#abb2bf,bg:#282c34,hl:#61afef',
  -- '--color=fg+:#DEE5F2,bg+:#282c34,hl+:#61afef',
  -- '--color=info:#5c6370,prompt:#5c6370,pointer:#61afef',
  -- '--color=marker:#98c379,spinner:#c678dd,header:#e06c75',
  -- COLOR NAMES:
  --     fg         Text
  '--color=fg:#abb2bf',
  --     bg         Background
  -- '--color=bg:#282c34',
  '--color=bg:#2c323c',
  --     preview-fg Preview window text
  --     preview-bg Preview window background
  '--color=preview-bg:#282c34',
  --     hl         Highlighted substrings
  '--color=hl:#61afef',
  --     fg+        Text (current line)
  '--color=hl+:#61afef',
  --     bg+        Background (current line)
  -- '--color=bg+:#282c34',
  '--color=bg+:#2c323c',
  --     gutter     Gutter on the left (defaults to bg+)
  --     hl+        Highlighted substrings (current line)
  '--color=hl+:#61afef',
  --     query      Query string
  --     disabled   Query string when search is disabled
  --     info       Info line (match counters)
  '--color=info:#5c6370',
  --     border     Border around the window (--border and --preview)
  -- '--color=border:#5c6370',
  '--color=border:#2c323c',
  --     prompt     Prompt
  '--color=prompt:#5c6370',
  --     pointer    Pointer to the current line
  '--color=pointer:#61afef',
  --     marker     Multi-select marker
  '--color=marker:#98c379',
  --     spinner    Streaming input indicator
  '--color=spinner:#c678dd',
  --     header     Header
  '--color=header:#e06c75',
}, ' ') .. '"')

  -- "--layout=reverse --bind ctrl-a:select-all"')

vim.g.fzf_layout = { window = { width = 0.9, height = 0.8 } }
vim.g.fzf_preview_window = { 'right:50%', '?' }

-- keep history
vim.g.fzf_history_dir = paths.dataDir .. '/fzf-history'

function _G.__open_file(file)
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)

    if name == file then
      return vim.api.nvim_set_current_win(win)
    end
  end

  vim.cmd('tabedit ' .. vim.fn.escape(file, ' '))
end

vim.cmd [[command! -nargs=* -bang FzfActionOpenFile lua _G.__open_file(<q-args>, <bang>0)]]

vim.g.fzf_action = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-x'] = 'split',
  ['ctrl-v'] = 'vsplit',
  ['ctrl-e'] = 'edit',
  ['enter']  = 'FzfActionOpenFile',
}

function _G.__fzf_rg(query, fullscreen)
  local command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- {q} || true'
  local command = command_fmt:gsub('{q}', vim.fn.shellescape(query))
  local preview = vim.fn['fzf#vim#with_preview']({
    options = { '--phony', '--layout=reverse', '--query', query, '--bind', 'change:reload:' .. command_fmt }
  })

  vim.fn['fzf#vim#grep'](command, true, preview, fullscreen)
end

vim.cmd [[command! -nargs=* -bang Find lua __fzf_rg(<q-args>, <bang>0)]]

-- Config
vim.cmd [[command! -bang FindConfig call fzf#vim#files('~/.config/nvim', fzf#vim#with_preview())]]


map('n', __keymaps.find_file, '<cmd>Files<cr>', { noremap = true })
map('n', __keymaps.find_string, '<cmd>Find<cr>', { noremap = true })
-- TODO find selection
-- map('v', __keymaps.find_string, '<cmd>Find<cr>', { noremap = true })
map('n', __keymaps.find_config, '<cmd>FindConfig<cr>', { noremap = true })

