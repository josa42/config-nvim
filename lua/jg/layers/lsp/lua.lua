local settings = {
  Lua = {
    runtime = {
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      globals = { 'vim', 'describe', 'it' },
      workspaceDelay = -1,
    },
    workspace = {
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  },
}

local M = {}

function M.setup(setup)
  setup('sumneko_lua', {
    settings = settings,
  })
end

return M
