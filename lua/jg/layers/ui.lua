local layer = require('jg.lib.layer')

-- quickfix list
layer.use({
  requires = {
    'kevinhwang91/nvim-bqf',
    'josa42/nvim-quickfix',
  },

  commands = {
    RG = { "lua require('jg.quickfix.tools').rg(<f-args>)", nargs = '+' },
    FD = { "lua require('jg.quickfix.tools').fd(<f-args>)", nargs = '+' },
  },

  setup = function()
    require('bqf').setup({
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        should_preview_cb = function(bufnr)
          return not vim.api.nvim_buf_get_name(bufnr):match('^fugitive://')
        end,
      },
    })
  end,
})

-- layer.use({
--   enabled = false,
--
--   name = 'quickfix-list',
--
--   requires = {
--     'LhKipp/nvim-locationist',
--   },
--
--   map = function()
--     local locationist = require('locationist')
--
--     local function add()
--       locationist.yank({ send_to = 'clist', comment = 'default' })
--     end
--
--     local function toggle()
--       local nr = vim.fn.winnr('$')
--       vim.cmd.cwindow()
--       if nr == vim.fn.winnr('$') then
--         vim.cmd.cclose()
--       end
--     end
--
--     local function refresh()
--       vim.cmd.copen()
--     end
--
--     return {
--       { 'n', '<leader>qa', add },
--       { 'n', '<leader>qq', toggle },
--       { 'n', '<leader>qr', refresh },
--     }
--   end,
--
--   setup = function()
--     require('locationist').setup({})
--
--     local function remove()
--       local curqfidx = vim.fn.line('.')
--       local qfall = vim.fn.getqflist()
--       table.remove(qfall, curqfidx)
--
--       vim.fn.setqflist(qfall, 'r')
--     end
--
--     vim.api.nvim_create_autocmd('FileType', {
--       pattern = 'qf',
--       callback = function(evt)
--         vim.keymap.set('n', 'dd', remove, {
--           buffer = evt.buf,
--         })
--       end,
--     })
--   end,
-- })

layer.use({
  requires = {
    'rcarriga/nvim-notify',
  },
  setup = function()
    local notify = require('notify')

    notify.setup({
      render = 'minimal',
      stages = 'fade',
      icons = {
        ERROR = _G.__icons.diagnostic.error,
        WARN = _G.__icons.diagnostic.warning,
        INFO = _G.__icons.diagnostic.info,
        DEBUG = '', -- _G.__icons.diagnostic.hint
        TRACE = '✎',
      },
    })

    vim.notify = notify
  end,
})

layer.use({
  requires = {
    'josa42/nvim-ui',
  },
})
