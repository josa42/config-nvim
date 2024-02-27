return {
  {
    'nvimtools/none-ls.nvim',

    config = function()
      local null_ls = require('null-ls')
      local utils = require('null-ls.utils')
      local find = require('config.utils.find')

      require('config.utils.mason').try_mason_install({
        'actionlint',
        'eslint_d',
        'fixjson',
        'gitlint',
        'shellcheck',
        'shfmt',
        'stylua',
        'vint',
        -- 'markuplint',
      })

      local root_pattern_pkg = utils.root_pattern('package.json')
      local root_pattern_eslint = utils.root_pattern(
        '.prettierrc',
        'prettierrc.json',
        '.prettierrc.cjs',
        '.prettierrc.js',
        'prettierrc.yaml',
        'prettierrc.yml'
      )

      local root_pattern_prettier = utils.root_pattern(
        '.eslintrc',
        'eslintrc.json',
        '.eslintrc.cjs',
        '.eslintrc.js',
        'eslintrc.yaml',
        'eslintrc.yml'
      )

      local if_not = function(fn)
        return function(p)
          return not fn(p)
        end
      end

      local cwd_eslint = function(p)
        local bufname = p and p.bufname or vim.api.nvim_buf_get_name(0)
        return root_pattern_eslint(bufname) or root_pattern_pkg(bufname)
      end

      local condition_eslint_without_json = function(p)
        return not find.eslint_json_parser(p.bufname) and find.eslint_bin(p.bufname)
      end

      local condition_eslint_with_json = function(p)
        return find.eslint_json_parser(p.bufname) and find.eslint_bin(p.bufname)
      end

      local condition_prettier = function(p)
        return find.prettier_bin(p.bufname) and root_pattern_prettier(p.bufname)
      end

      local condition_prettier_markdown = function(p)
        return os.getenv('NVIMV_ENABLE_PRETTIER_MARKDOWN') == '1' and find.prettier_bin(p.bufname)
      end

      local condition_prettier_yaml = function(p)
        return os.getenv('NVIMV_ENABLE_PRETTIER_YAML') == '1' and find.prettier_bin(p.bufname)
      end

      null_ls.setup({
        debug = false, -- log: ~/.cache/nvim/null-ls.log
        sources = {
          -- -- eslint -> js; without json
          -- null_ls.builtins.diagnostics.eslint_d.with({
          --   runtime_condition = condition_eslint_without_json,
          --   cwd = cwd_eslint,
          -- }),
          -- null_ls.builtins.formatting.eslint_d.with({
          --   runtime_condition = condition_eslint_without_json,
          --   cwd = cwd_eslint,
          -- }),
          --
          -- -- eslint -> js and json
          -- null_ls.builtins.diagnostics.eslint_d.with({
          --   -- filetypes = js_and_json,
          --   runtime_condition = condition_eslint_with_json,
          --   cwd = cwd_eslint,
          -- }),
          -- null_ls.builtins.formatting.eslint_d.with({
          --   -- filetypes = js_and_json,
          --   runtime_condition = condition_eslint_with_json,
          --   cwd = cwd_eslint,
          -- }),

          -- fixjson
          null_ls.builtins.formatting.fixjson.with({
            runtime_condition = if_not(condition_eslint_with_json),
          }),

          -- -- prettier -> javascript
          -- null_ls.builtins.formatting.prettier.with({
          --   filetypes = { 'javascript', 'javascriptreact' },
          --   runtime_condition = condition_prettier,
          -- }),
          --
          -- -- prettier -> markdown
          -- null_ls.builtins.formatting.prettier.with({
          --   filetypes = { 'markdown' },
          --   runtime_condition = condition_prettier_markdown,
          -- }),
          --
          -- -- prettier -> yaml
          -- null_ls.builtins.formatting.prettier.with({
          --   filetypes = { 'yaml' },
          --   runtime_condition = condition_prettier_yaml,
          -- }),

          null_ls.builtins.formatting.stylua,

          null_ls.builtins.formatting.shfmt.with({
            extra_args = {
              ('-i=%d'):format(vim.bo.shiftwidth), -- indent: 0 for tabs (default), >0 for number of spaces
              '-bn', -- binary ops like && and | may start a line
              '-ci', -- switch cases will be indented
              '-sr', -- keep column alignment paddings
              '-kp', -- function opening braces are placed on a separate line
            },
          }),

          -- yaml
          -- action lint
          null_ls.builtins.diagnostics.actionlint.with({
            runtime_condition = function(params)
              return params.bufname:match('.*%.github/workflows/.*%.yml')
            end,
          }),

          -- shell
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.diagnostics.zsh,

          -- swift
          null_ls.builtins.formatting.swiftformat,

          -- terraform
          null_ls.builtins.formatting.terraform_fmt,

          -- git
          null_ls.builtins.diagnostics.gitlint,

          -- html
          -- TODO enable when issue is resolved; https://github.com/nvimtools/none-ls.nvim/issues/51
          -- null_ls.builtins.diagnostics.markuplint,

          -- php
          null_ls.builtins.diagnostics.php,

          -- vimscript
          null_ls.builtins.diagnostics.vint,
        },
      })
    end,
  },
}
