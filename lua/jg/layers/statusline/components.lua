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

return M
