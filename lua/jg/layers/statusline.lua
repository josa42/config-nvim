local layer = require('jg.lib.layer')

local M = {}

layer.use({
  require = {
    'nvim-lualine/lualine.nvim',
    'arkav/lualine-lsp-progress',
  },

  after = function()
    require('lualine').setup({
      options = {
        theme = 'auto',
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '⏐', right = '⏐' },
        disabled_filetypes = { 'tree' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          { 'filename', path = 1 },
          'require("jg.layers.statusline").client_names()',
          -- 'require("jg.lualine-lsp").messages()',
          'lsp_progress',
        },
        lualine_c = { 'branch', { 'diagnostics', sources = { 'nvim_lsp' } } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'filetype' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { 'filename', path = 1 },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'filetype' },
      },
      tabline = {},
      extensions = {},
    })
  end,
})

function M.client_names()
  local clients = {}
  local icon = ' '

  for _, client in pairs(vim.lsp.buf_get_clients()) do
    clients[#clients + 1] = icon .. client.name
  end

  return table.concat(clients, ' ')
end

function M.messages()
  local messages = {}

  for _, client in pairs(vim.lsp.buf_get_clients()) do
    for _, progress in pairs(client.messages.progress) do
      if not progress.done then
        table.insert(messages, progress.title .. ': ' .. progress.message)
      end
    end
  end

  return table.concat(messages, ' | ')
end

return M
