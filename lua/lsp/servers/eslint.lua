return function()
  return {
    settings = {
      quiet = true,
    },

    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })
    end,
  }
end
