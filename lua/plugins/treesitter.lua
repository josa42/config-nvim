-- See: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    opts = {
      -- install_dir
    },
    config = function(_, opts)
      require('config.utils.mason').try_mason_install({
        'tree-sitter-cli',
      })

      local ts = require('nvim-treesitter')

      ts.setup(opts)
      ts.install('all')

      -- Enable highlighting and indent for all filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)

          -- if not vim.treesitter.language.add(lang) then
          --   if vim.tbl_contains(ts.get_available(), lang) then
          --     ts.install(lang)
          --   end
          -- end

          if lang and vim.treesitter.language.add(lang) then
            -- vim.notify_once('Treesitter: ' .. lang .. ' parser is enabled', vim.log.levels.INFO)
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })
    end,
  },
}
