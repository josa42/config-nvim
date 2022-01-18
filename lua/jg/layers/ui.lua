local layer = require('jg.lib.layer')

layer.use({
  enabled = true,

  requires = {
    'stevearc/dressing.nvim',
    'MunifTanjim/nui.nvim',
  },

  setup = function()
    require('dressing').setup({
      input = {
        anchor = 'NW',
        row = 1,
      },
      select = {
        get_config = function(opts)
          if opts.kind == 'codeaction' or opts.kind == 'file' then
            return {
              backend = 'nui',
              nui = {
                relative = 'cursor',
                position = 1,
                size = {
                  width = opts.width,
                },
              },
            }
          end

          return {
            backend = 'nui',
            nui = {
              relative = opts.relative,
              position = opts.position,
              size = {
                width = opts.width,
              },
              max_width = opts.max_width,
              max_height = opts.max_height,
            },
          }
        end,
      },
    })
  end,
})
