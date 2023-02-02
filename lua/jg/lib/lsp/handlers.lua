local util = require('vim.lsp.util')

local M = {}

local function on_location(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    return
  end

  local client = vim.lsp.get_client_by_id(ctx.client_id)

  if not vim.tbl_islist(result) then
    result = { result }
  end

  if #result == 1 then
    util.jump_to_location(result[1], client.offset_encoding, false)
  else
    vim.ui.select(result, {
      kind = 'file',
      format_item = function(loc)
        return vim.fn.fnamemodify(vim.uri_to_fname(loc.uri), ':~:.')
      end,
    }, function(loc)
      if loc then
        util.jump_to_location(loc, client.offset_encoding, false)
      end
    end)
  end
end

function M.setup()
  vim.lsp.handlers['textDocument/declaration'] = on_location
  vim.lsp.handlers['textDocument/definition'] = on_location
  vim.lsp.handlers['textDocument/typeDefinition'] = on_location
  vim.lsp.handlers['textDocument/implementation'] = on_location

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'single',
    width = 50,
  })

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      spacing = 8,
      prefix = '',
      severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
      format = function(d)
        local icon = '■'

        if d.severity == vim.diagnostic.severity.ERROR then
          icon = _G.__icons.diagnostic.error
        elseif d.severity == vim.diagnostic.severity.WARN then
          icon = _G.__icons.diagnostic.warning
        end

        local message = icon .. ' ' .. d.message

        -- local l = vim.fn.strchars(vim.fn.getline(d.lnum + 1))
        -- if l < 78 then
        --   return string.rep(' ', 78 - l) .. message
        -- end

        return message
      end,
    },
  })
end

return M
