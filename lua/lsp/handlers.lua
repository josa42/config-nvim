-- local util = require('vim.lsp.util')
local signs = require('config.signs')

local M = {}

-- local function on_location(_, result, ctx, _)
--   if result == nil or vim.tbl_isempty(result) then
--     return
--   end
--
--   if not vim.tbl_islist(result) then
--     result = { result }
--   end
--
--   if #result == 1 then
--     local client = vim.lsp.get_client_by_id(ctx.client_id)
--     util.jump_to_location(result[1], client.offset_encoding, false)
--     -- util.preview_location(result[1], { max_width = 100, max_height = 8 })
--   else
--     vim.ui.select(result, {
--       kind = 'file',
--       format_item = function(loc)
--         return vim.fn.fnamemodify(vim.uri_to_fname(loc.uri), ':~:.')
--       end,
--     }, function(loc)
--       if loc then
--         util.jump_to_location(loc, client.offset_encoding, false)
--         -- util.preview_location(loc, { max_width = 100, max_height = 8 })
--       end
--     end)
--   end
-- end

function M.setup()
  -- vim.lsp.handlers['textDocument/declaration'] = on_location
  -- vim.lsp.handlers['textDocument/definition'] = on_location
  -- vim.lsp.handlers['textDocument/typeDefinition'] = on_location
  -- vim.lsp.handlers['textDocument/implementation'] = on_location

  vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = false,
  })
end

return M
