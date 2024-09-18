local M = {}

function M.new_window(cmd)
  vim.fn.system({ 'tmux', 'new-window', cmd })
end

function M.display_popup(cmd)
  vim.fn.system({ 'tmux', 'display-popup', '-E', cmd })
end

function M.lazygit_file(cmd)
  local file = vim.fn.expand('%')
  local root = vim.fs.root(file, { '.git' })

  M.display_popup(('lazygit --filter=%s --path=%s'):format(vim.fn.expand('%:p'), root))
end

return M
