local M = {}

-- Filter diagnostics
function M.on_publish_diagnostics(_, result, ...)
  -- Hide some diagnostics
  result.diagnostics = vim.tbl_filter(function(diagnostic)
    if
      -- File is a CommonJS module; it may be converted to an ES6 module.
      diagnostic.code == 80001 and diagnostic.source == 'typescript'
      -- Could not find a declaration file for module '<module>'.
      or diagnostic.code == 7016 and diagnostic.source == 'typescript'
    then
      return false
    end

    return true
  end, result.diagnostics or {})

  return require('vim.lsp.diagnostic').on_publish_diagnostics(nil, result, ...)
end
