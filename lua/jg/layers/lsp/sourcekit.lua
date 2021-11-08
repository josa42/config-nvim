local lsp = require('lspconfig')

local M = {}

function M.setup(setup)
  setup(lsp.sourcekit)
end

return M

