-- stylelint-lsp
local paths = require('jg.lib.paths')
local null_ls = require('null-ls')
local helpers = require('null-ls.helpers')

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

local eslint_d = helpers.conditional(function(utils)
  if utils.root_has_file('node_modules/.bin/eslint') then
    if utils.root_has_file('node_modules/jsonc-eslint-parser/package.json') then
      return null_ls.builtins.diagnostics.eslint_d.with({
        command = eslint_d_bin,
        filetypes = jsAndJson,
      })
    else
      return null_ls.builtins.diagnostics.eslint_d.with({ command = eslint_d_bin })
    end
  end
end)

local eslint_d_formatter = helpers.conditional(function(utils)
  if utils.root_has_file('node_modules/.bin/eslint') then
    if utils.root_has_file('node_modules/jsonc-eslint-parser/package.json') then
      return null_ls.builtins.formatting.eslint_d.with({
        command = eslint_d_bin,
        filetypes = jsAndJson,
      })
    else
      return null_ls.builtins.formatting.eslint_d.with({ command = eslint_d_bin })
    end
  end
end)

local M = {}

function M.setup()
  null_ls.setup({
    debug = false, -- log: ~/.cache/nvim/null-ls.log
    sources = {
      eslint_d,
      eslint_d_formatter,
      null_ls.builtins.formatting.fixjson.with({
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
      null_ls.builtins.code_actions.gitsigns,
    },
  })
end

return M
