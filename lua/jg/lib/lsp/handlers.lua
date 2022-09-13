local util = require('vim.lsp.util')

local M = {}

-- Filter diagnostics
function M.filtered_on_publish_diagnostics(ignored_codes)
  return function(_, result, ...)
    -- Hide some diagnostics
    result.diagnostics = vim.tbl_filter(function(diagnostic)
      return not vim.tbl_contains(ignored_codes[diagnostic.source] or {}, diagnostic.code)
    end, result.diagnostics or {})

    return require('vim.lsp.diagnostic').on_publish_diagnostics(nil, result, ...)
  end
end

function M.on_location(_, result, ctx, _)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end

  local client = vim.lsp.get_client_by_id(ctx.client_id)

  if not vim.tbl_islist(result) then
    result = { result }
  end

  if #result == 1 then
    util.jump_to_location(result[1], client.offset_encoding)
  else
    vim.ui.select(result, {
      kind = 'file',
      format_item = function(loc)
        return vim.fn.fnamemodify(vim.uri_to_fname(loc.uri), ':~:.')
      end,
    }, function(loc)
      if loc then
        util.jump_to_location(loc)
      end
    end)
  end
end

function M.setup(opts)
  opts = opts or {}
  if opts.diagnostics_ignored_codes then
    vim.lsp.handlers['textDocument/publishDiagnostics'] =
      M.filtered_on_publish_diagnostics(opts.diagnostics_ignored_codes)
  end
  vim.lsp.handlers['textDocument/declaration'] = M.on_location
  vim.lsp.handlers['textDocument/definition'] = M.on_location
  vim.lsp.handlers['textDocument/typeDefinition'] = M.on_location
  vim.lsp.handlers['textDocument/implementation'] = M.on_location
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = 'single',
    width = 50,
  })

  -- open_floating_preview
end

return M
