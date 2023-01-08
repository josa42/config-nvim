local paths = require('jg.lib.paths')

local settings = {
  yaml = {
    schemas = {
      ['http://json.schemastore.org/github-workflow'] = {
        '.github/workflows/*.yml',
      },
      ['http://json.schemastore.org/github-action'] = {
        '.github/actions/*/actions.yml',
      },
      ['file:///Users/josa/github/josa42/run/schema/tasks.json'] = {
        'tasks.yml',
      },
      ['file://' .. paths.home .. '/github/josa42/scheme-lazygit/lazygit.schema.json'] = {
        paths.home .. '/.config/lazygit/config.yml',
      },

      ['https://goreleaser.com/schema.json'] = {
        '.goreleaser.yml',
      },
    },
  },
}

return function()
  return {
    settings = settings,
  }
end
