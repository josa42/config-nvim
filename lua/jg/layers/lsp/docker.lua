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

function M.setup(setup)
  setup('dockerls', {
    settings = settings,
  })

  au.group('jg.lsp.docker.auto-format', function(cmd)
    cmd({ on = { 'BufWritePre', 'InsertLeave' }, pattern = 'Dockerfile' }, vim.lsp.buf.formatting)
  end)
end

return M
