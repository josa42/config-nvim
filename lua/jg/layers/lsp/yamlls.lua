local paths = require('jg.lib.paths')

local settings = {
  yaml = {
    disableAdditionalProperties = false,
    schemaStore = { enable = true },
    schemas = {
      ['file://' .. paths.config_home .. '/json-schema/tmuxinator.schema.json'] = {
        '/Users/josa/.tmuxinator/*.yml',
      },
      ['file://' .. paths.config_home .. '/json-schema/bitbucket-pipeline.schema.json'] = {
        'bitbucket-pipelines.yml',
      },
      ['file://' .. paths.config_home .. '/json-schema/alacritty.schema.json'] = {
        'alacritty.yml',
      },
      ['http://json.schemastore.org/github-workflow'] = {
        '.github/workflows/*.yml',
      },
      ['http://json.schemastore.org/github-action'] = {
        '.github/actions/*/actions.yml',
      },
      -- ['https://raw.githubusercontent.com/josa42/run/master/schema/tasks.json'] = {
      --   'tasks.yml'
      -- },
      ['file:///Users/josa/github/josa42/run/schema/tasks.json'] = {
        'tasks.yml',
      },

      -- ['https://goreleaser.com/schema.json'] = {
      --   '.goreleaser.yml'
      -- }
    },
  },
}

return function()
  return {
    settings = settings,
  }
end
