-- local configs = require('lspconfig/configs')
-- local util = require 'lspconfig.util'
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

return function()
  return {
    settings = {
      packageManager = 'yarn',
      quiet = true,
    },
  }
end
