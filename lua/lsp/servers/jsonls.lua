local settings = {
  json = {
    schemas = require('schemastore').json.schemas(),
    validate = { enable = true },
    -- schemas = {
    --   {
    --     fileMatch = { '.eslintrc', '.eslintrc.json' },
    --     url = 'http://json.schemastore.org/eslintrc',
    --   },
    --   {
    --     fileMatch = { 'package.json' },
    --     url = 'http://json.schemastore.org/package',
    --   },
    --   {
    --     fileMatch = { '*.schema.json' },
    --     url = 'http://json-schema.org/draft-07/schema#',
    --   },
    -- },
  },
}

return function()
  return {
    filetypes = { 'json', 'jsonc' },
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
        end,
      },
    },
    settings = settings,
  }
end
