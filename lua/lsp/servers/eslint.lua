return function()
  return {
    settings = {
      quiet = true,
    },

    -- TODO enable running fix only if eslint is available

    -- on_init = function(client)
    --   local path = client.workspace_folders[1].name
    --
    --   vim.notify('eslint: ' .. path, vim.log.levels.INFO)
    --
    --   -- if path == '/path/to/project1' then
    --   --   client.config.settings['rust-analyzer'].checkOnSave.overrideCommand = { 'cargo', 'check' }
    --   -- elseif path == '/path/to/rust' then
    --   --   client.config.settings['rust-analyzer'].checkOnSave.overrideCommand =
    --   --     { 'python3', 'x.py', 'check', '--stage', '1' }
    --   -- end
    --
    --   -- client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
    --   return true
    -- end,

    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })
    end,
  }
end
