local M = {}

function M.smart_open(file)
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

return M

