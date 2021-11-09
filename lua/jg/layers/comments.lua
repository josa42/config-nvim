local layer = require('jg.lib.layer')

layer.use({
  require = { 'tomtom/tcomment_vim' },

  map = {
    { 'n', '#', '<Plug>TComment_gcc' },
    { 'v', '#', '<Plug>TComment_gc' },
  },

  before = function()
    vim.g.tcomment_maps = 1
    vim.g.tcomment_mapleader1 = ''
    vim.g.tcomment_mapleader2 = ''
    vim.g.tcomment_opleader1 = 'gc'
    vim.g.tcomment_mapleader_uncomment_anyway = ''
    vim.g.tcomment_mapleader_comment_anyway = ''
    vim.g.tcomment_textobject_inlinecomment = 'ic'
  end,

  after = function()
    vim.fn['tcomment#type#Define']('jsonc', '// %s')
    vim.fn['tcomment#type#Define']('jsonc_block', vim.g['tcomment#block_fmt_c'])
    vim.fn['tcomment#type#Define']('jsonc_inline', vim.g['tcomment#inline_fmt_c'])
    vim.fn['tcomment#type#Define']('json', '// %s')
    vim.fn['tcomment#type#Define']('json_block', vim.g['tcomment#block_fmt_c'])
    vim.fn['tcomment#type#Define']('json_inline', vim.g['tcomment#inline_fmt_c'])
    vim.fn['tcomment#type#Define']('monkeyc', '// %s')
    vim.fn['tcomment#type#Define']('monkeyc_block', vim.g['tcomment#block_fmt_c'])
    vim.fn['tcomment#type#Define']('monkeyc_inline', vim.g['tcomment#inline_fmt_c'])
  end,
})
