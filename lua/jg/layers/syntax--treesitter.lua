if os.getenv('NVIM_TS') ~= 'true' then
  return
end

local plug = require('jg.lib.plug')

plug.require({ 'nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' } })
plug.after(function()
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    -- playground = {
    --     enable = true,
    --     disable = {},
    --     updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    --     persist_queries = false -- Whether the query persists across vim sessions
    -- },
    highlight = { enable = true },
    indent = { enable = true },
    autotag = { enable = true },
    rainbow = { enable = true },
    context_commentstring = { enable = true, config = { javascriptreact = { style_element = '{/*%s*/}' } } },
  })
end)
