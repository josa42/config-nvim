local layer = require('jg.lib.layer')
local paths = require('jg.lib.paths')

local snipptes_dir = ('%s/snippets'):format(paths.config_dir)

layer.use({
  requires = {
    'L3MON4D3/LuaSnip',
  },

  commands = function(fn)
    return {
      SnippetEdit = function()
        require('luasnip.loaders').edit_snippet_files({ edit = vim.cmd.tabe })
      end,
      SnippetReload = function()
        fn.load_snippets({ cleanup = true })
      end,
    }
  end,

  autocmds = {
    {
      'BufWritePost',
      pattern = ('%s/*.json'):format(snipptes_dir),
      callback = function(opts)
        require('luasnip.loaders').reload_file(opts.file)
      end,
    },
  },

  setup = function(fn)
    local luasnip = require('luasnip')

    luasnip.setup({
      delete_check_events = 'TextChanged',
    })
    fn.load_snippets()
  end,

  fn = {
    load_snippets = function(opts)
      opts = opts or { cleanup = false }

      local luasnip = require('luasnip')
      local from_vscode = require('luasnip.loaders.from_vscode')
      local from_lua = require('luasnip.loaders.from_lua')

      if opts.cleanup then
        luasnip.cleanup()
      end
      from_vscode.load({ paths = { './snippets' } })
      from_lua.load({ paths = { './snippets' } })
    end,
  },
})
