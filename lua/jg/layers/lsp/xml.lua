local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local M = {}

local xmLS = paths.lspBin .. ''

function M.setup(setup)
  -- lsp.yamlls.setup{
  --   cmd = { xmLS, '--stdio' },
  --   capabilities = lsp_utils.make_client_capabilities(),
  -- }
end

return M
