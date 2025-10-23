return function()
  return {
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    
    settings = {
      quiet = true,
      codeActionOnSave = {
        enable = true,
        mode = 'all',
      },
      format = true,
      workingDirectories = { mode = 'auto' },
    },

    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })
    end,

    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue',
      'svelte',
      'astro',
    },
  }
end
