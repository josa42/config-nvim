-- See: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local ts_install = 'all'
local ts_disable = { 'help' }

if vim.fn.has('nvim-0.13') == 1 then
  return {
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      branch = 'main',
      build = ':TSUpdate',
      opts = {
        -- install_dir
      },
      config = function(opts)
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
              vim.treesitter.start(args.buf, lang)
            end
          end,
        })

        -- Apply treesitter to buffers opened before this config ran
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            local ft = vim.bo[buf].filetype
            if ft ~= '' then
              local lang = vim.treesitter.language.get_lang(ft)
              if lang and vim.treesitter.language.add(lang) then
                vim.treesitter.start(buf, lang)
              end
            end
          end
        end
      end,
    },
  }
else
  return {
    {
      'nvim-treesitter/nvim-treesitter',
      branch = 'master',
      version = false,
      lazy = true,
      -- event = 'BufReadPre',
      -- priority = 100,

      build = ':TSUpdate',
      event = { 'BufReadPre' },
      cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },

      init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treeitter** module to be loaded in time.
        -- Luckily, the only thins that those plugins need are the custom queries, which we make available
        -- during startup.
        require('lazy.core.loader').add_to_rtp(plugin)
        require('nvim-treesitter.query_predicates')
      end,

      dependencies = {
        'nvim-treesitter/playground',
      },

      keys = {
        {
          '<space>t',
          ':TSHighlightCapturesUnderCursor<CR>',
        },
      },

      config = function()
        local parser_install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'tree-sitter')

        -- prepend path to make sure bundled parsers are not used
        vim.opt.runtimepath:prepend(parser_install_dir)

        -- use bash parser for zsh
        vim.treesitter.language.register('bash', 'zsh')

        require('nvim-treesitter.configs').setup({
          ensure_installed = ts_install,
          ignore_install = ts_disable,
          parser_install_dir = parser_install_dir,

          highlight = {
            enable = true,
            disable = ts_disable,
          },
          indent = { enable = true, disable = ts_disable },
          autotag = { enable = false },
        })

        -- Remove conceal for markdown code fences
        pcall(function()
          local file_path = vim.treesitter.query.get_files('markdown', 'highlights')[1]
          local file = io.open(file_path, 'r')
          if file then
            io.input(file)
            local content = io.read('*a')
              :gsub('%(fenced_code_block\n  %(fenced_code_block_delimiter%) @conceal\n  %(#set! conceal ""%)%)', '; -')
              :gsub('%(fenced_code_block\n  %(info_string %(language%) @conceal\n  %(#set! conceal ""%)%)', '; -')

            vim.treesitter.query.set('markdown', 'highlights', content)
          end
        end)
      end,
    },
  }
end
