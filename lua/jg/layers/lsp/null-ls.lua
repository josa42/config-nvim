-- stylelint-lsp
local paths = require('jg.lib.paths')
local null_ls = require('null-ls')

local M = {}

local function bin(name)
  local bin_path = paths.lspBin .. '/' .. name

  if vim.fn.executable(bin_path) == 1 then
    return bin_path
  end

  if vim.fn.executable(name) ~= 1 then
    vim.notify_once('binary for "' .. name .. '" is not installed')
  end

  return name
end

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

function M.setup()
  local utils = require('null-ls.utils')
  local yarn_root = utils.root_pattern('.yarn')
  local pkg_root = utils.root_pattern('package.json')

  local eslint_root = function(p)
    local bufname = p and p.bufname or vim.api.nvim_buf_get_name(0)
    return yarn_root(bufname) or pkg_root(bufname)
  end

  local has_file = function(root, name)
    return utils.path.exists(utils.path.join(root, name))
  end

  local condition_eslint = function(u)
    return u.root_has_file('node_modules/.bin/eslint')
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
        condition = condition_eslint,
        runtime_condition = condition_eslint_without_json,
        command = bin('eslint_d'),
      }),
      null_ls.builtins.formatting.eslint_d.with({
        condition = condition_eslint,
        runtime_condition = condition_eslint_without_json,
        command = bin('eslint_d'),
      }),

      -- eslint -> js and json
      null_ls.builtins.diagnostics.eslint_d.with({
        condition = condition_eslint,
        runtime_condition = condition_eslint_with_json,
        command = bin('eslint_d'),
        filetypes = jsAndJson,
      }),
      null_ls.builtins.formatting.eslint_d.with({
        condition = condition_eslint,
        runtime_condition = condition_eslint_with_json,
        command = bin('eslint_d'),
        filetypes = jsAndJson,
      }),

      -- fixjson
      null_ls.builtins.formatting.fixjson.with({
        runtime_condition = condition_not_eslint_with_json,
        command = bin('fixjson'),
      }),

      null_ls.builtins.formatting.stylua.with({
        command = bin('stylua'),
      }),

      null_ls.builtins.formatting.shfmt.with({
        command = bin('shfmt'),
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
        command = bin('actionlint'),
        args = { '-no-color', '-format', '{{json .}}', '--shellcheck=' .. bin('shellcheck'), '-' },
      }),
      null_ls.builtins.diagnostics.shellcheck.with({
        command = bin('shellcheck'),
      }),

      null_ls.builtins.formatting.swiftformat,
    },
  })
end

return M
