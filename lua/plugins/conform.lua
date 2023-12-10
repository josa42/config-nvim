local function extend(name, opts)
  return vim.tbl_deep_extend('force', require('conform.formatters.' .. name), opts)
end

return {
  {
    'stevearc/conform.nvim',
    lazy = false,
    opts = {
      formatters_by_ft = {
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        json = { 'eslint_d_json', 'fixjson' },
        lua = { 'stylua' },
        markdown = { 'prettier_markdown' },
        sh = { 'shfmt' },
        swift = { 'swiftformat' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        yaml = { 'prettier_yaml' },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    --
    config = function(_, opts)
      -- run when mason is set up
      require('config.utils.mason').try_mason_install({
        'fixjson',
        'shfmt',
        'stylua',
        'eslint_d',
      })

      local conform = require('conform')
      local c = require('config.utils.find')

      conform.setup(opts)

      local formatters = conform.formatters

      formatters.shfmt = {
        prepend_args = function(self, ctx)
          return {
            '-i=2', -- indent: 0 for tabs (default), >0 for number of spaces
            '-bn', -- binary ops like && and | may start a line
            '-ci', -- switch cases will be indented
            '-sr', -- keep column alignment paddings
            '-kp', -- function opening braces are placed on a separate line
          }
        end,
      }

      formatters.eslint_d = {
        cwd = c.any(c.root_eslintrc),
        condition = c.all(c.eslint_bin),
      }

      formatters.eslint_d_json = extend('eslint_d', {
        cwd = c.any(c.root_eslintrc),
        condition = c.all(c.eslint_json_parser),
      })

      formatters.prettier_markdown = extend('prettier', {
        condition = c.all(c.if_env('NVIM_ENABLE_PRETTIER_MARKDOWN'), c.prettier_bin),
      })

      formatters.prettier_yaml = extend('prettier', {
        condition = c.all(c.if_env('NVIM_ENABLE_PRETTIER_YAML'), c.prettier_bin),
      })
    end,
  },
}
