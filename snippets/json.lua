local luasnip = require('luasnip')

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

local rep = require('luasnip.extras').rep

local paths = require('jg.lib.paths')
local snipptes_dir = paths.config_dir .. '/snippets'

local is_json_snippet = function()
  return vim.fn.expand('%:p:h') == snipptes_dir
end

return {
  -- "${1}": {
  --   "prefix": [
  --     "${1}"
  --   ],
  --   "description": "${2}",
  --   "body": [
  --     "${3}"
  --   ],
  -- }
  s('snippet', {
    t({ '"' }),
    i(1),
    t({ '": {', '\t"prefix": [', '\t\t"' }),
    rep(1),
    t({ '"', '\t],', '\t"description": "' }),
    i(2),
    t({ '",', '' }),
    t({ '\t"body": [', '' }),
    t({ '\t\t"' }),
    i(3, '<body>'),
    t({ '"' }),
    i(4),
    t({ '', '' }),
    t({ '\t],', '}' }),
    i(0),
  }, {
    show_condition = is_json_snippet,
  }),
}
