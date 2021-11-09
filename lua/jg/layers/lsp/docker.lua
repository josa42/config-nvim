local lsp = require('lspconfig')
local paths = require('jg.lib.paths')
local au = require('jg.lib.autocmd')

local settings = {
  docker = {
    languageserver = {
      -- diagnostics?: {
      --   // string values must be equal to "ignore", "warning", or "error"
      --   deprecatedMaintainer?: string,
      --   directiveCasing?: string,
      --   emptyContinuationLine?: string,
      --   instructionCasing?: string,
      --   instructionCmdMultiple?: string,
      --   instructionEntrypointMultiple?: string,
      --   instructionHealthcheckMultiple?: string,
      --   instructionJSONInSingleQuotes?: string
      -- }
    },
  },
}

local M = {}

local dockerLS = paths.lspBin .. '/docker-langserver'

function M.setup(setup)
  setup(lsp.dockerls, {
    cmd = { dockerLS, '--stdio' },
    settings = settings,
  })

  au.group('jg.lsp.go', function(cmd)
    cmd({ on = { 'BufWritePre', 'InsertLeave' }, pattern = 'Dockerfile' }, vim.lsp.buf.formatting)
  end)
end

return M
