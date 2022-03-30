local util = require('vim.lsp.util')

local M = {}

local ignored_codes = {
  typescript = {
    7016, --  Could not find a declaration file for module '<module>'.
    80001, -- File is a CommonJS module; it may be converted to an ES6 module.
    80002, -- This constructor function may be converted to a class declaration.
  },
}

-- Filter diagnostics
function M.on_publish_diagnostics(_, result, ...)
  -- Hide some diagnostics
  result.diagnostics = vim.tbl_filter(function(diagnostic)
    return not vim.tbl_contains(ignored_codes[diagnostic.source] or {}, diagnostic.code)
  end, result.diagnostics or {})

  return require('vim.lsp.diagnostic').on_publish_diagnostics(nil, result, ...)
end

function M.on_location(_, result, _, _)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end

  if not vim.tbl_islist(result) then
    result = { result }
  end

  if #result == 1 then
    util.jump_to_location(result[1])
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

function M.setup()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = M.on_publish_diagnostics
  vim.lsp.handlers['textDocument/declaration'] = M.on_location
  vim.lsp.handlers['textDocument/definition'] = M.on_location
  vim.lsp.handlers['textDocument/typeDefinition'] = M.on_location
  vim.lsp.handlers['textDocument/implementation'] = M.on_location
end

return M
