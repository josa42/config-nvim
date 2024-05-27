local settings = {
  Lua = {
    runtime = {
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
      special = {
        include = 'require',
      },
    },
    diagnostics = {
      globals = { 'describe', 'it' },
      workspaceDelay = -1,
    },
    workspace = {
      checkThirdParty = 'Apply',
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
