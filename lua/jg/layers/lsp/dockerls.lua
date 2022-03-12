require('jg.lib.polyfills')

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

return function()
  local group = vim.api.nvim_create_augroup('jg.lsp.docker.auto-format', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufWritePre', 'InsertLeave' }, {
    group = group,
    pattern = 'Dockerfile',
    callback = vim.lsp.buf.formatting,
  })

  return {
    settings = settings,
  }
end
