-- stylelint-lsp
local null_ls = require('null-ls')
local utils = require('null-ls.utils')
local mason = require('mason-registry')

local M = {}

M.tools = {
  'actionlint',
  'eslint_d',
  'fixjson',
  'shellcheck',
  'shfmt',
  'stylua',
  'editorconfig-checker',
}

local js_and_json = {
  'json',
  'jsonc',
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'svelte',
}

function M.setup()
  for _, tool in ipairs(M.tools) do
    local pkg = mason.get_package(tool)
    if not pkg:is_installed() then
      pkg:install()
    end
  end

  local eslintrc_root =
    utils.root_pattern('.eslintrc', 'eslintrc.json', '.eslintrc.js', 'eslintrc.yaml', 'eslintrc.yml')
  local yarn_root = utils.root_pattern('.yarn')
  local pkg_root = utils.root_pattern('package.json')

  local eslint_root = function(p)
    local bufname = p and p.bufname or vim.api.nvim_buf_get_name(0)
    return eslintrc_root(bufname) or yarn_root(bufname) or pkg_root(bufname)
  end

  local has_file = function(root, name)
    return utils.path.exists(utils.path.join(root, name))
  end

  local condition_eslint_without_json = function(p)
    local root = eslint_root(p)
    return has_file(root, 'node_modules/.bin/eslint')
      and not has_file(root, 'node_modules/jsonc-eslint-parser/package.json')
  end

  local condition_eslint_with_json = function(p)
    local root = eslint_root(p)
    return has_file(root, 'node_modules/.bin/eslint')
      and has_file(root, 'node_modules/jsonc-eslint-parser/package.json')
  end

  local condition_not_eslint_with_json = function(p)
    return not condition_eslint_with_json(p)
  end

  null_ls.setup({
    debug = false, -- log: ~/.cache/nvim/null-ls.log
    sources = {
      -- eslint -> js; without json
      null_ls.builtins.diagnostics.eslint_d.with({
        runtime_condition = condition_eslint_without_json,
        cwd = eslint_root,
      }),
      null_ls.builtins.formatting.eslint_d.with({
        runtime_condition = condition_eslint_without_json,
        cwd = eslint_root,
      }),

      -- eslint -> js and json
      null_ls.builtins.diagnostics.eslint_d.with({
        filetypes = js_and_json,
        runtime_condition = condition_eslint_with_json,
        cwd = eslint_root,
      }),
      null_ls.builtins.formatting.eslint_d.with({
        filetypes = js_and_json,
        runtime_condition = condition_eslint_with_json,
        cwd = eslint_root,
      }),

      -- fixjson
      null_ls.builtins.formatting.fixjson.with({
        runtime_condition = condition_not_eslint_with_json,
      }),

      null_ls.builtins.formatting.stylua,

      null_ls.builtins.formatting.shfmt.with({
        extra_args = {
          '-i=2', -- indent: 0 for tabs (default), >0 for number of spaces
          '-bn', -- binary ops like && and | may start a line
          '-ci', -- switch cases will be indented
          '-sr', -- keep column alignment paddings
          '-kp', -- function opening braces are placed on a separate line
        },
      }),

      -- action lint
      null_ls.builtins.diagnostics.actionlint.with({
        runtime_condition = function(params)
          return params.bufname:match('.*%.github/workflows/.*%.yml')
        end,
      }),

      null_ls.builtins.diagnostics.shellcheck,

      null_ls.builtins.formatting.swiftformat,

      null_ls.builtins.diagnostics.editorconfig_checker.with({
        command = 'editorconfig-checker',
        runtime_condition = function(opt)
          return opt.bufname:find('/node_modules/') == nil and not opt.bufname:match('.*/yarn.lock$')
        end,
      }),
    },
  })
end

return M
