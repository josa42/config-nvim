local layer = require('jg.lib.layer')

local M = {}

layer.use({
  requires = {
    'nvim-lualine/lualine.nvim',
    'arkav/lualine-lsp-progress',
  },

  setup = function()
    local cp = function(trg, src)
      return vim.tbl_deep_extend('force', trg, src)
    end

    vim.cmd([[
      hi! StatusLineNC guibg=#21252B
      hi! StatusLine   guibg=#21252B
    ]])

    local theme = cp({}, require('lualine.themes.auto'))
    theme.normal.a.bg = '#21252B'
    theme.normal.b.bg = '#21252B'
    theme.normal.c.bg = '#21252B'

    for _, mode in ipairs({ 'command', 'insert', 'visual', 'terminal', 'replace' }) do
      theme[mode].b = theme.normal.b
      theme[mode].c = theme.normal.c
      theme[mode].x = theme.normal.c
      theme[mode].y = theme.normal.b
      theme[mode].z = theme.normal.a
    end

    require('lualine').setup({
      options = {
        theme = theme,
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
          { 'diagnostics', sources = { 'nvim_diagnostic' } },
        },
        lualine_c = {
          'branch',
          'b:gitsigns_status',
        },
        lualine_x = {},
        lualine_y = { 'filesize' },
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
