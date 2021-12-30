-- stylelint-lsp
local paths = require('jg.lib.paths')
local null_ls = require('null-ls')

local M = {}

local fixjson_bin = paths.lspBin .. '/fixjson'
local eslint_d_bin = paths.lspBin .. '/eslint_d'
local stylua_bin = paths.lspBin .. '/stylua'
local shfmt_bin = paths.lspBin .. '/shfmt'

local jsAndJson = {
  'json',
  'jsonc',
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'svelte',
}

local condition_eslint = function(utils)
  return utils.root_has_file('node_modules/.bin/eslint')
    and not utils.root_has_file('node_modules/jsonc-eslint-parser/package.json')
end

local condition_eslint_with_json = function(utils)
  return utils.root_has_file('node_modules/.bin/eslint')
    and utils.root_has_file('node_modules/jsonc-eslint-parser/package.json')
end

local condition_not_eslint_with_json = function(utils)
  return not condition_eslint_with_json(utils)
end

function M.setup()
  null_ls.setup({
    debug = false, -- log: ~/.cache/nvim/null-ls.log
    sources = {
      -- eslint -> js; without json
      null_ls.builtins.diagnostics.eslint_d.with({
        condition = condition_eslint,
        command = eslint_d_bin,
      }),
      null_ls.builtins.formatting.eslint_d.with({
        condition = condition_eslint,
        command = eslint_d_bin,
      }),

      -- eslint -> js and json
      null_ls.builtins.diagnostics.eslint_d.with({
        condition = condition_eslint_with_json,
        command = eslint_d_bin,
        filetypes = jsAndJson,
      }),
      null_ls.builtins.formatting.eslint_d.with({
        condition = condition_eslint_with_json,
        command = eslint_d_bin,
        filetypes = jsAndJson,
      }),

      -- fixjson
      null_ls.builtins.formatting.fixjson.with({
        condition = condition_not_eslint_with_json,
        command = fixjson_bin,
      }),

      null_ls.builtins.formatting.stylua.with({
        command = stylua_bin,
      }),

      null_ls.builtins.formatting.shfmt.with({
        command = shfmt_bin,
        extra_args = {
          '-i=2', -- indent: 0 for tabs (default), >0 for number of spaces
          '-bn', -- binary ops like && and | may start a line
          '-ci', -- switch cases will be indented
          '-sr', -- keep column alignment paddings
          '-kp', -- function opening braces are placed on a separate line
        },
      }),
    },
  })
end

return M
