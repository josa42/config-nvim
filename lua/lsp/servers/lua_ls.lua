-- nvim_get_runtime_file('') returns the runtime *roots*, not the lua/
-- directories holding the vim.* type definitions, so add those explicitly.
-- Without them lua_ls offers no vim.* completions in files that sit outside a
-- Neovim config or plugin, where lazydev also stays disabled.
local function library()
  local paths = vim.api.nvim_get_runtime_file('', true)
  table.insert(paths, vim.fs.joinpath(vim.env.VIMRUNTIME, 'lua'))
  table.insert(paths, vim.fs.joinpath(vim.env.VIMRUNTIME, 'lua/vim/_meta'))
  return paths
end

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
      library = library(),
    },
    telemetry = { enable = false },
  },
}

return function()
  return {
    settings = settings,

    -- Fall back to the file's own directory so a standalone .lua file still
    -- gets a workspace, and with it the library above.
    root_dir = function(bufnr, on_dir)
      local root = vim.fs.root(bufnr, { '.luarc.json', '.luarc.jsonc', 'lua', '.git' })
      on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
    end,
  }
end
