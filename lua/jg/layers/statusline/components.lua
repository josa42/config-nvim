local M = {}

function M.lazy_status()
  local ok, lazy_status = pcall(require, 'lazy.status')
  if ok then
    return {
      lazy_status.updates,
      cond = lazy_status.has_updates,
      color = 'DiagnosticWarn',
      on_click = function()
        vim.cmd('Lazy')
      end,
    }
  end
end

function M.luasnip_status()
  local ok, luasnip = pcall(require, 'luasnip')
  if ok then
    return function()
      if not luasnip.expand_or_jumpable() then
        return ''
      end

      local icon = ('%s%s'):format('%#StatusLuasnipIcon#', '%#StatusLuasnip#')

      local actions = {}

      if luasnip.jumpable() then
        table.insert(actions, '')
      end

      if luasnip.choice_active() then
        table.insert(actions, '(choices)')
      end

      if #actions > 0 then
        return ('%s %s'):format(icon, table.concat(actions, ' '))
      end

      return icon
    end
  end
end

return M
