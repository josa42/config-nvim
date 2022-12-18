local settings = {
  Lua = {
    runtime = {
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      globals = { 'vim', 'describe', 'it', 'require' },
      workspaceDelay = -1,
    },
    workspace = {
      checkThirdParty = false,
      library = vim.api.nvim_get_runtime_file('', true),
    },
    telemetry = { enable = false },
  },
}

return function()
  return {
    settings = settings,
  }
end
