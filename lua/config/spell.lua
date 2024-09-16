vim.keymap.set('n', 'z=', function()
  local word = vim.fn.expand('<cword>')

  vim.ui.select(
    vim.fn.spellsuggest(word),
    { prompt = ('Change %s to:'):format(vim.inspect(word)) },
    vim.schedule_wrap(function(_, idx)
      if type(idx) == 'number' and idx > 0 then
        vim.cmd.normal({ ('%dz='):format(idx), bang = true })
      end
    end)
  )
end, { desc = 'Shows spelling suggestions' })
