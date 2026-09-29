-- Ported from the typescript-tools.nvim setup. vtsls takes VS Code's settings
-- shape, so the tsserver_file_preferences keys map onto typescript.inlayHints.*
-- and javascript.inlayHints.*. Note that two of them invert: the old
-- include*When*MatchesName options become suppressWhen*MatchesName.

local inlay_hints = {
  parameterNames = {
    enabled = 'all',
    suppressWhenArgumentMatchesName = false,
  },
  parameterTypes = { enabled = true },
  variableTypes = {
    enabled = true,
    suppressWhenTypeMatchesName = false,
  },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

local format = {
  indentSize = 2,
  tabSize = 2,
  convertTabsToSpaces = true,
}

-- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
local ignored_diagnostics = {
  -- 7016, -- Could not find a declaration file for module '<module>'.
  80001, -- File is a CommonJS module; it may be converted to an ES6 module.
  80002, -- This constructor function may be converted to a class declaration.
}

return function()
  return {
    settings = {
      vtsls = {
        experimental = {
          -- Keep completions responsive on large projects.
          completion = { enableServerSideFuzzyMatch = true },
        },
      },
      typescript = {
        inlayHints = inlay_hints,
        format = format,
        preferences = { organizeImports = { caseSensitivity = 'insensitive' } },
      },
      javascript = {
        inlayHints = inlay_hints,
        format = format,
      },
    },

    handlers = {
      ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        if result and result.diagnostics then
          result.diagnostics = vim.tbl_filter(function(d)
            return not vim.tbl_contains(ignored_diagnostics, d.code)
          end, result.diagnostics)
        end
        vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx, config)
      end,
    },
  }
end
