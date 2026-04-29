return function()
  local default_config = vim.lsp.config.eslint

  local eslint_config_files = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'eslint.config.cts',
  }

  return {
    cmd = { 'vscode-eslint-language-server', '--stdio' },

    settings = {
      validate = 'on',
      quiet = true,
      codeActionOnSave = {
        enable = true,
        mode = 'all',
      },
      format = true,
      -- Defaults the ESLint language server expects but does not guard against
      -- being absent. Without these, resolveSettings() throws because it
      -- accesses e.g. path.isAbsolute(undefined) or settings.experimental.useFlatConfig.
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

    root_dir = function(bufnr, on_dir)
      -- local callback_on_dir = function(dir)
      --   vim.notify('===> ESLINT ROOT ===> ' .. dir, vim.log.levels.INFO)
      --   on_dir(dir)
      -- end
      local callback_on_dir = on_dir

      local name = vim.api.nvim_buf_get_name(bufnr)

      -- TODO not sure if needed
      local config_path = vim.fs.find(eslint_config_files, { path = name, upward = true })[1]
      if config_path then
        return callback_on_dir(vim.fs.dirname(config_path))
      end

      default_config.root_dir(bufnr, callback_on_dir)
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
