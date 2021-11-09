local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local M = {}

local htmlLS = paths.lspBin .. '/vscode-html-language-server'

function M.setup(setup)
  setup(lsp.html, {
    cmd = { htmlLS, '--stdio' },
  })
end

return M
