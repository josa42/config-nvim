local layer = require('jg.lib.layer')
local paths = require('jg.lib.paths')

layer.use({
  requires = { 'hrsh7th/vim-vsnip' },

  map = {
    { 'i', '<Tab>', "vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'", { expr = true } },
    { 's', '<Tab>', "vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'", { expr = true } },
    { 'i', '<S-Tab>', "vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'", { expr = true } },
    { 's', '<S-Tab>', "vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'", { expr = true } },
  },

  init = function()
    vim.g.vsnip_snippet_dir = paths.configDir .. '/vsnip'
  end,
})
