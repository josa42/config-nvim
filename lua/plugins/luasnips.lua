local function load_snippets(opts)
  opts = opts or { cleanup = false }

  local luasnip = require('luasnip')
  local from_vscode = require('luasnip.loaders.from_vscode')
  local from_lua = require('luasnip.loaders.from_lua')

  if opts.cleanup then
    luasnip.cleanup()
  end
  from_vscode.load({ paths = { './snippets' } })
  from_lua.load({ paths = { './snippets' } })
end

return {
  {
    'L3MON4D3/LuaSnip',
    opts = {
      delete_check_events = 'TextChanged',
      update_events = 'TextChanged,TextChangedI',
      region_check_events = 'CursorMoved',
    },
    config = function(_, opts)
      require('luasnip').setup(opts)
      load_snippets()
    end,
  },
}
