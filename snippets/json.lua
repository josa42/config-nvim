local luasnip = require('luasnip')

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local sn = luasnip.snippet_node

local rep = require('luasnip.extras').rep

local paths = require('jg.lib.paths')
local snipptes_dir = paths.config_dir .. '/snippets'

local is_json_snippet = function()
  return vim.fn.expand('%:p:h') == snipptes_dir
end

local function empty(str)
  return str:match('^%s*$') ~= nil
end

local function whitespace_prefix(str)
  return #str:match('%s*')
end

local function strip_prefix(tbl)
  local pre = 0
  local first = true

  for _, str in ipairs(tbl) do
    local str_pre = whitespace_prefix(str)
    if (first or str_pre < pre) and not empty(str) then
      pre = str_pre
      first = false
    end
  end

  local l = {}
  for _, str in ipairs(tbl) do
    table.insert(l, str:sub(pre + 1))
  end

  return l
end

return {
  -- "${1}": {
  --   "prefix": [
  --     "${1}"
  --   ],
  --   "description": "${2}",
  --   "body": [
  --     "${3:$CLIPBOARD|empty}"
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
    t('\t\t'),

    -- choice: clipboard or empty string
    c(3, {
      f(function(args, snip)
        if snip.env.CLIPBOARD == '$CLIPBOARD' then
          return '$CLIPBOARD'
        end

        local clipboard = vim.fn.getreg('+', 1, true)
        local out = {}

        if vim.tbl_islist(clipboard) then
          for idx, line in ipairs(strip_prefix(clipboard)) do
            local indent = idx == 1 and '' or '\t\t'
            local comma = idx < #clipboard and ',' or ''

            table.insert(out, ('%s"%s"%s'):format(indent, line:gsub('"', '\\"'), comma))
          end
        end

        return out
      end),
      sn(4, { t('"'), i(1), t('"'), i(2) }),
    }),
    t({ '', '' }),
    t({ '\t],', '}' }),
    i(0),
  }, {
    show_condition = is_json_snippet,
  }),
}
