local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local M = {}

local emmet_ls = paths.lspBin .. '/emmet-ls'

function M.setup(setup)
  setup(lsp.emmet_ls, {
    cmd = { emmet_ls, '--stdio' },
  })
end

return M
