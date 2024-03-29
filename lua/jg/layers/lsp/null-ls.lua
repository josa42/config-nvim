-- stylelint-lsp
local null_ls = require('null-ls')
local utils = require('null-ls.utils')
local mason = require('mason-registry')

local M = {}

M.tools = {
  'actionlint',
  'fixjson',
  'shellcheck',
  'shfmt',
  'stylua',
  'editorconfig-checker',
  'eslint_d',
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
    return M.cache[key].value
  end
  return default
end

function M.set_cache(key, value)
  -- print('set  --> ' .. key .. ' = ' .. vim.json.encode(value))
  M.cache[key] = { value = value }
  return value
end

function M.cached(key_base, fn)
  return function(...)
    local key = table.concat(
      vim.tbl_map(function(a)
        local t = type(a)
        if t == 'table' and a.bufname ~= nil then
          return a.bufname
        end

        return a
      end, { key_base, ... }),
      ':'
    )

    if M.has_cache(key) then
      -- print('get  --> ' .. key .. ' = ' .. vim.json.encode(M.get_cache(key)))
      return M.get_cache(key)
    end

    return M.set_cache(key, fn(...))
  end
end

local function path_join(...)
  local path = utils.path.join(...)
  return path
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
    return (root ~= nil and name ~= nil) and utils.path.exists(path_join(root, name))
  end

  local npm_bin_dir = M.cached('npm_bin_dir', function(p)
    local root = eslint_root(p)

    -- TODO npm bin has been removed in npm 9
    local out = vim.trim(vim.fn.system('cd ' .. vim.fn.shellescape(root) .. '; npm bin'))

    if utils.path.exists(out) then
      return path_join(root, 'node_modules', '.bin')
    end

    return nil
  end)

  local find_in_dir = M.cached('find_in_dir', function(dir, name)
    if has_file(dir, name) then
      return path_join(dir, name)
    end

    return nil
  end)

  local find_bin_using_npm_query = M.cached('find_bin_using_npm_query', function(dir, name)
    local ok, res = pcall(function()
      local cmd = ('cd %s; npm query \\#%s'):format(vim.fn.shellescape(dir, name))
      local eslint = vim.json.decode(vim.fn.system(cmd))
      if eslint and eslint[1] ~= nil then
        return path_join(eslint[1].path, eslint[1].bin.eslint)
      end
    end)

    if ok then
      return res
    end

    return nil
  end)

  local find_in_repo = M.cached('find_in_repo', function(dir, rel_path)
    if not dir or not rel_path then
      return nil
    end

    local home = os.getenv('HOME')

    while true do
      for _, p in ipairs(vim.fn.glob(path_join(dir, rel_path), true, true)) do
        if utils.path.exists(p) then
          return p
        end
      end

      if utils.path.exists(path_join(dir, '.git')) or vim.tbl_contains({ home, '/', '.' }, dir) then
        return nil
      end

      dir = vim.fs.dirname(dir)
    end
  end)

  local find_local_bin = M.cached('find_local_bin', function(p, name)
    local checkers = {
      function()
        return find_in_dir(npm_bin_dir(p), name)
      end,
      function()
        return find_bin_using_npm_query(pkg_root(p.bufname), name)
      end,
      function()
        if name == 'eslint' then
          return find_in_dir(path_join(eslint_root(p), 'node_modules', '.bin'), name)
        end
      end,
      function()
        return find_in_repo(vim.fs.dirname(p.bufname), path_join('node_modules', '.bin', name))
      end,
    }

    for _, fn in ipairs(checkers) do
      local bin = fn()
      if bin ~= nil then
        return bin
      end
    end

    return nil
  end)

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
