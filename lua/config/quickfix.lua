local group = vim.api.nvim_create_augroup('qf.commands', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = group,
  pattern = { 'qf' },
  callback = function(evt)
    vim.keymap.set('n', 'dd', function()
      local line = vim.fn.line('.')
      vim.fn.setqflist(
        vim.fn.filter(vim.fn.getqflist(), function(idx)
          return idx ~= line - 1
        end),
        'r'
      )
      vim.api.nvim_win_set_cursor(0, { math.min(line, vim.fn.line('$')), 0 })
    end, { buffer = evt.buf })
    -- vim.keymap.set('n', '<c-j>', vim.cmd.cnext, { buffer = evt.buf })
    -- vim.keymap.set('n', '<c-k>', vim.cmd.cprevious, { buffer = evt.buf })
  end,
})
