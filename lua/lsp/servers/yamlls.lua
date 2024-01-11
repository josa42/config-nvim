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
  }
end
