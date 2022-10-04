local M = {}

local function organize_imports()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = '',
  }
  vim.lsp.buf.execute_command(params)
end

return function()
  return {
    commands = {
      OrganizeImports = {
        organize_imports,
        description = 'Organize Imports',
      },
    },
    settings = {
      diagnostics = {
        ignoredCodes = {
          -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
          7016, --  Could not find a declaration file for module '<module>'.
          80001, -- File is a CommonJS module; it may be converted to an ES6 module.
          80002, -- This constructor function may be converted to a class declaration.
        },
      },
    },
  }
end
