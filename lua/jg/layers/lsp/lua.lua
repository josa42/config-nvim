local lsp = require('lspconfig')
local paths = require('jg.lib.paths')

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

local root_path = paths.lspBin .. '/lua-language-server'
local server_bin = root_path .. '/bin/macOS/lua-language-server'
local main = root_path .. '/main.lua'

function M.setup(setup)
  setup(lsp.sumneko_lua, {
    cmd = { server_bin, '-E', main },
    settings = settings,
  })
end

return M
