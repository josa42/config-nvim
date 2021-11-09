local lsp = require('lspconfig')
local configs = require('lspconfig/configs')

local M = {}

configs.bcr_ls = {
  default_config = {
    cmd = { 'node', '/Users/jgesell/github/josa42/bcr-tools/bcr-ls/main.js', '--stdio' },
    -- cmd = {'/Users/jgesell/go/bin/bcr-ls'};
    filetypes = { 'javascript', 'json' },
    root_dir = lsp.util.root_pattern('package.json', 'jsconfig.json', '.git'),
    settings = {
      trace = { server = 'verbose' },
    },
  },
}

function M.setup(setup)
  setup(lsp.bcr_ls)
end

return M
