-- function goto(count)
--   return function()
--     if vim.fn.has('nvim-0.11') == 1 then
--       vim.diagnostic.jump({ count = count })
--     else if count == 1 then
--         vim.diagnostic.goto_next()
--       else
--         vim.diagnostic.goto_prev()
--       end
--     end
--   end
-- end

return {
  -- keys = {
  --   { '<leader>bd', vim.diagnostic.setqflist, mode = 'n' }, -- Buffer Diagnostics
  --   { '<leader>ld', vim.diagnostic.open_float, mode = 'n' }, -- Line Diagnostics
  --   { '<leader>jd', goto(1), mode = 'n' }, -- Next Diagnostic
  --   { '<leader>kd', goto(-1), mode = 'n' }, -- Prev Diagnostic
  -- },
}
