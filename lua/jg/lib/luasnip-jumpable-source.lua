local cmp = require('cmp')
local luasnip = require('luasnip')

local M = {}

M.new = function()
  return setmetatable({}, { __index = M })
end

function M:is_available()
  return true
  -- return luasnip.jumpable(1)
end

-- M.get_position_encoding_kind = function()
--   return 'utf-8'
-- end
--
M.get_keyword_pattern = function()
  return ''
end

function M:execute(completion_item, callback)
  print('==> execute')
  -- callback()
  luasnip.jumpable(1)
end

function M:complete(params, callback)
  print('==> complete')
  local items = {}

  -- local item = {
  --   label = 'Jump =>',
  --   insertText = '',
  --   kind = cmp.lsp.CompletionItemKind.Keyword,
  -- }

  local item = {
    label = '=> jump',
    filterText = '',
    insertText = '',
    word = '',
    preselect = true,
  }

  table.insert(items, item)
  callback(items)

  -- callback({ isIncomplete = true, items = items })
end

return M
