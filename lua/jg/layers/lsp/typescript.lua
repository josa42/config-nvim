local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local M = {}

local typescriptLS = paths.lspBin .. '/typescript-language-server'
local tsserver = paths.lspBin .. '/tsserver'

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

function M.setup(setup)
  setup(lsp.tsserver, {
    cmd = { typescriptLS, '--tsserver-path', tsserver, '--stdio' },
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports"
      }
    }
  })
end

return M


