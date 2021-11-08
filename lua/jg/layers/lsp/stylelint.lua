-- stylelint-lsp
local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

local M = {}

local stylelintLS = paths.lspBin .. '/stylelint-lsp'

function M.setup(setup)
  setup(lsp.stylelint_lsp, {
    cmd = { stylelintLS, '--stdio' },
    filetypes = { "css", "less", "scss" },
    settings= {
      stylelintplus = {
        autoFixOnFormat = true,
      },
    }
  })
end

return M


