local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local M = {}

local bashLS = paths.lspBin .. '/bash-language-server'

function M.setup(setup)
  setup(lsp.bashls, {
    cmd = { bashLS, 'start' },
  })
end

return M
