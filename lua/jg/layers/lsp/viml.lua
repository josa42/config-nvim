local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local M = {}

local vimLS = paths.lspBin .. '/vim-language-server'

function M.setup(setup)
  setup(lsp.vimls, {
    cmd = { vimLS, '--stdio' },
  })
end

return M

