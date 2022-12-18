local layer = require('jg.lib.layer')
local paths = require('jg.lib.paths')

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
      pattern = ('%s/snippets/*.json'):format(paths.config_dir),
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

      if opts.cleanup then
        luasnip.cleanup()
      end
      from_vscode.load({ paths = { './snippets' } })
    end,
  },
})
