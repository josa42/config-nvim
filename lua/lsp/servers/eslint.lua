return function()
  local eslint_config_files = {
    {
      'eslint.config.js',
      'eslint.config.mjs',
      'eslint.config.cjs',
      'eslint.config.ts',
      'eslint.config.mts',
      'eslint.config.cts',
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      '.eslintrc.json',
    },
  }

  return {
    cmd = { 'vscode-eslint-language-server', '--stdio' },

    settings = {
      validate = 'on',
      -- quiet = true,
      workingDirectory = { directory = vim.fn.getcwd() },
      codeActionOnSave = {
        enable = true,
        mode = 'all',
      },
      format = true,
      nodePath = vim.NIL,
      experimental = {},
      problems = { shortenToSingleLine = false },
      options = {},
      rulesCustomizations = {},
      run = 'onType',
      packageManager = 'npm',
      useFlatConfig = vim.NIL,
    },

    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.code_action({
            context = { only = { 'source.fixAll.eslint' }, diagnostics = {} },
            apply = true,
          })
        end,
      })
    end,

    before_init = function(_, config)
      -- Lock ESLint's working directory to the resolved package root so
      -- typescript-eslint's projectService resolves tsconfig.json correctly.
      local root = type(config.root_dir) == 'string' and config.root_dir or vim.fn.getcwd()
      config.settings = config.settings or {}
      config.settings.workingDirectory = { directory = root }
    end,

    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, eslint_config_files)
      if root then
        return on_dir(root)
      end

      on_dir(vim.fn.getcwd())
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
