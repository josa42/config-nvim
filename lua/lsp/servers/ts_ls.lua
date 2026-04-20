return function()
  local default_config = vim.lsp.config.ts_ls
  return {
    root_dir = function(bufnr, on_dir)
      -- local callback_on_dir = function(dir)
      --   vim.notify('===> TS ROOT ===> ' .. dir, vim.log.levels.INFO)
      --   on_dir(dir)
      -- end
      local callback_on_dir = on_dir

      local name = vim.api.nvim_buf_get_name(bufnr)

      -- TODO not sure if needed
      local config_path = vim.fs.find({ 'tsconfig.json' }, { path = name, upward = true })[1]
      if config_path then
        return callback_on_dir(vim.fs.dirname(config_path))
      end

      default_config.root_dir(bufnr, callback_on_dir)
    end,

    settings = {
      diagnostics = {
        ignoredCodes = {
          -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
          7016, --  Could not find a declaration file for module '<module>'.
          80001, -- File is a CommonJS module; it may be converted to an ES6 module.
          80002, -- This constructor function may be converted to a class declaration.
        },
      },
    },
  }
end
