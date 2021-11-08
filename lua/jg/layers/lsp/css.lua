local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local M = {}

local cssLS = paths.lspBin .. '/vscode-css-language-server'

function M.setup(setup)
  setup(lsp.cssls, {
    cmd = { cssLS, '--stdio' },
  })
end

return M
