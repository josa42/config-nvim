-- local configs = require('lspconfig/configs')
local lsp = require('lspconfig')
-- local util = require 'lspconfig.util'
local paths = require('jg.lib.paths')

-- configs.eslint = {
--   default_config = {
--     cmd = { paths.lspBin .. '/eslint-ls', '--stdio' },
--     filetypes = { 'javascript', 'typescript', 'json', 'jsonc' };
--     root_dir = util.root_pattern(".eslintrc", '.eslintrc.json', '.eslintrc.js')
--   };
-- };
--
-- local M = {}
--
-- local eslintLS = paths.lspBin .. '/eslint-ls'
--
-- function M.setup(setup)
--   setup(lsp.eslint, {
--     cmd = { eslintLS, '--stdio' },
--   })
-- end
--
-- return M

local M = {}

local eslintLS = paths.lspBin .. '/vscode-eslint-language-server'

function M.setup(setup)
  setup(lsp.eslint, {
    cmd = { eslintLS, '--stdio', '--debug' },
    settings = {
      packageManager = 'yarn',
      quiet = true,
    }
  })
end

return M
