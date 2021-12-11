local layer = require('jg.lib.layer')

layer.use({
  enabled = true,

  require = {
    'stevearc/dressing.nvim',
    'MunifTanjim/nui.nvim',
  },

  after = function()
    require('dressing').setup({
      input = {
        anchor = 'NW',
        row = 1,
      },
      select = {
        backend = { 'nui' },
        get_config = function(opts)
          if opts.kind == 'codeaction' or opts.kind == 'file' then
            return {
              backend = 'nui',
              nui = {
                relative = 'cursor',
                position = 1,
              },
            }
          end
        end,
      },
    })
  end,
})
