local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local settings = {
  json = {
    schemas = {
      {
        fileMatch = { '.eslintrc', '.eslintrc.json' },
        url = 'http://json.schemastore.org/eslintrc'
      },
      {
        fileMatch = { 'package.json' },
        url = 'http://json.schemastore.org/package'
      },
      {
        fileMatch = { "*.schema.json" },
        url = 'http://json-schema.org/draft-07/schema#',
      }
    }
  }
}

local M = {}

local jsonLS = paths.lspBin .. '/vscode-json-language-server'

function M.setup(setup)
  setup(lsp.jsonls, {
    cmd = { jsonLS, '--stdio' },
    filetypes = { 'json', 'jsonc' },
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    },
    settings = settings,
  })
end

return M
