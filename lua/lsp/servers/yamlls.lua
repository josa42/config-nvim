local settings = {
  yaml = {
    schemaStore = {
      -- You must disable built-in schemaStore support if you want to use
      -- this plugin and its advanced options like `ignore`.
      enable = false,
      -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      url = '',
    },
    schemas = require('schemastore').yaml.schemas({
      extra = {
        {
          fileMatch = { 'tasks.yml' },
          name = 'tasks.json',
          url = ('file://%s'):format(vim.fn.expand('~/run/schema/tasks.json')),
        },
      },
    }),
  },
}

return function()
  return {
    settings = settings,
    handlers = {
      ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        if result and result.diagnostics then
          result.diagnostics = vim.tbl_filter(function(d)
            return not d.message:match('^Unresolved tag:')
          end, result.diagnostics)
        end
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
      end,
    },
  }
end
