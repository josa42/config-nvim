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
  'markdown',
}

M.cache = {}

function M.has_cache(key)
  return M.cache[key] ~= nil
end

function M.get_cache(key, default)
  if M.has_cache(key) then
    return M.cache[key]
  end
  return default
end

function M.set_cache(key, value)
  M.cache[key] = value
  return value
end

function M.setup()
  for _, tool in ipairs(M.tools) do
    local pkg = mason.get_package(tool)
    if not pkg:is_installed() then
      pkg:install()
    end
  end

  local eslintrc_root =
    utils.root_pattern('.eslintrc', 'eslintrc.json', '.eslintrc.cjs', '.eslintrc.js', 'eslintrc.yaml', 'eslintrc.yml')

  local not_home = function(fn)
    local home = os.getenv('HOME')
    return function(bufname)
      local dir = fn(bufname)
      if dir == home then
        return nil
      end
      return dir
    end
  end

  local yarn_root = not_home(utils.root_pattern('.yarn'))
  local pkg_root = not_home(utils.root_pattern('package.json'))

  local eslint_root = function(p)
    local bufname = p and p.bufname or vim.api.nvim_buf_get_name(0)
    return eslintrc_root(bufname) or yarn_root(bufname) or pkg_root(bufname)
  end

  local has_file = function(root, name)
    return utils.path.exists(utils.path.join(root, name))
  end

  local function npm_bin_dir(p)
    local cache_key = 'npm:bin:dir:' .. p.bufname
    if M.has_cache(cache_key) then
      return M.get_cache(cache_key)
    end

    local root = eslint_root(p)

    -- TODO npm bin has been removed in npm 9
    local out = vim.trim(vim.fn.system('cd ' .. vim.fn.shellescape(root) .. '; npm bin'))

    if utils.path.exists(out) then
      return M.set_cache(cache_key, utils.path.join(root, 'node_modules', '.bin'))
    end

    return M.set_cache(cache_key, '.')
  end

  local function find_local_bin(p, name)
    local cache_key = 'local:bin:' .. p.bufname .. ':' .. name
    if M.has_cache(cache_key) then
      return M.get_cache(cache_key)
    end

    local bin_dir = npm_bin_dir(p)
    if has_file(bin_dir, name) then
      return M.set_cache(cache_key, utils.path.join(bin_dir, name))
    end

    if name == 'eslint' then
      local dir = vim.fs.dirname(p.bufname)
      local eslint = vim.json.decode(vim.fn.system('cd ' .. vim.fn.shellescape(dir) .. '; npm query \\#eslint'))[1]
      if eslint ~= nil then
        return M.set_cache(cache_key, utils.path.join(eslint.path, eslint.bin.eslint))
      end
    end

    return nil
  end

  local condition_eslint_without_json = function(p)
    local root = eslint_root(p)
    return not has_file(root, 'node_modules/jsonc-eslint-parser/package.json') and find_local_bin(p, 'eslint') ~= nil
  end

  local condition_eslint_with_json = function(p)
    local root = eslint_root(p)
    return has_file(root, 'node_modules/jsonc-eslint-parser/package.json') and find_local_bin(p, 'eslint') ~= nil
  end

  local condition_not_eslint_with_json = function(p)
    return not condition_eslint_with_json(p)
  end

  local condition_prettier_markdown = function(p)
    return os.getenv('NVIMV_ENABLE_PRETTIER_MARKDOWN') == '1' and has_file(eslint_root(p), 'node_modules/.bin/prettier')
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

      -- fixjson
      null_ls.builtins.formatting.prettier.with({
        filetypes = { 'markdown' },
        runtime_condition = condition_prettier_markdown,
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

      -- null_ls.builtins.diagnostics.editorconfig_checker.with({
      --   command = 'editorconfig-checker',
      --   runtime_condition = function(opt)
      --     return opt.bufname:find('/node_modules/') == nil and not opt.bufname:match('.*/yarn.lock$')
      --   end,
      -- }),

      null_ls.builtins.formatting.terraform_fmt,
      null_ls.builtins.code_actions.refactoring,
    },
  })
end

return M
