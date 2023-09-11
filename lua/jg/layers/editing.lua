local layer = require('jg.lib.layer')

layer.use({
  requires = { 'numToStr/Navigator.nvim' },
  setup = function()
    vim.keymap.set('n', '<leader>l', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>')

    require('Navigator').setup()
  end,
  map = {
    { { 'n', 't' }, '<c-h>', '<CMD>NavigatorLeft<CR>' },
    { { 'n', 't' }, '<c-l>', '<CMD>NavigatorRight<CR>' },
    { { 'n', 't' }, '<c-k>', '<CMD>NavigatorUp<CR>' },
    { { 'n', 't' }, '<c-j>', '<CMD>NavigatorDown<CR>' },
    { { 'n', 't' }, '<c-space>', '<CMD>NavigatorPrevious<CR>' },
  },
})

--------------------------------------------------------------------------------

layer.use({
  map = {
    -- move lines
    { 'n', 'g<up>', ':m -2<cr>', desc = 'Move Line Up' },
    { 'n', 'g<down>', ':m +1<cr>', desc = 'Move Line Down' },
    { 'v', 'g<up>', ":m '<-2<CR>gv=gv", desc = 'Move Selection Up' },
    { 'v', 'g<down>', ":m '>+1<CR>gv=gv", desc = 'Move Selection Down' },

    -- redo
    { 'n', '<S-U>', '<C-R>', desc = 'Redo' },
  },
})

--------------------------------------------------------------------------------

layer.use({
  map = {
    {
      'n',
      'gr',
      function()
        local formatexpr = vim.opt.formatexpr
        vim.opt.formatexpr = nil
        vim.cmd.normal({ 'mzgqip`z', bang = true })
        vim.opt.formatexpr = formatexpr
      end,
    },
    {
      'v',
      'gr',
      function()
        local formatexpr = vim.opt.formatexpr
        vim.opt.formatexpr = nil
        vim.cmd.normal({ 'mzgq`z', bang = true })
        vim.opt.formatexpr = formatexpr
      end,
    },
  },
})

--------------------------------------------------------------------------------

layer.use({
  requires = { 'tpope/vim-repeat' },
})

--------------------------------------------------------------------------------

layer.use({
  requires = { 'AndrewRadev/splitjoin.vim' },
})

--------------------------------------------------------------------------------

layer.use({
  requires = { 'AndrewRadev/sideways.vim' },
  map = {
    { 'n', 'g<left>', ':SidewaysLeft<cr>' },
    { 'n', 'g<right>', ':SidewaysRight<cr>' },

    -- argument text objects
    { 'o', 'aa', '<Plug>SidewaysArgumentTextobjA' },
    { 'x', 'aa', '<Plug>SidewaysArgumentTextobjA' },
    { 'o', 'ia', '<Plug>SidewaysArgumentTextobjI' },
    { 'x', 'ia', '<Plug>SidewaysArgumentTextobjI' },

    -- inserting arguments
    { 'n', '<leader>si', '<Plug>SidewaysArgumentInsertBefore' },
    { 'n', '<leader>sa', '<Plug>SidewaysArgumentAppendAfter' },
    { 'n', '<leader>sI', '<Plug>SidewaysArgumentInsertFirst' },
    { 'n', '<leader>sA', '<Plug>SidewaysArgumentAppendLast' },
  },
})

--------------------------------------------------------------------------------

layer.use({
  requires = { 'windwp/nvim-autopairs' },
  setup = function()
    require('nvim-autopairs').setup({
      html_break_line_filetype = {
        'html',
        'javascript',
        'javascriptreact',
        'svelte',
        'template',
        'typescriptreact',
        'vue',
      },
    })
  end,
})

--------------------------------------------------------------------------------

layer.use({
  requires = {
    'windwp/nvim-ts-autotag',
  },

  setup = function()
    require('nvim-ts-autotag').setup()
  end,
})

--------------------------------------------------------------------------------
-- Aligning

layer.use({
  requires = { 'junegunn/vim-easy-align' }, -- Column align: ga
  map = {
    -- Start interactive EasyAlign in visual mode (e.g. vipga)
    { 'x', 'ga', '<Plug>(EasyAlign)' },
    -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
    { 'n', 'ga', '<Plug>(EasyAlign)' },
  },
})

--------------------------------------------------------------------------------
-- Motion actions

layer.use({
  requires = { 'josa42/nvim-actions' },
  setup = function()
    -- sort actions: gs / gz
    require('jg.actions').setup()
  end,
})

--------------------------------------------------------------------------------
-- Surround

layer.use({
  requires = {
    'kylechui/nvim-surround',
  },

  setup = function()
    require('nvim-surround').setup({
      keymaps = {
        insert = nil, -- '<C-g>s',
        insert_line = nil, -- '<C-g>S',
        normal = 'sa',
        normal_cur = nil, --  'yss',
        normal_line = nil, --  'yS',
        normal_cur_line = nil, --  'ySS',
        visual = 'sa',
        visual_line = nil, --  'gS',
        delete = 'sd',
        change = 'sr',
      },
      surrounds = {
        v = { add = { '${', '}' } },
      },
    })
  end,
})

--------------------------------------------------------------------------------
-- Toogle values

layer.use({
  requires = { 'AndrewRadev/switch.vim' },

  autocmds = {
    {
      'FileType',
      callback = function()
        vim.b.switch_custom_definitions = {}
      end,
    },
    {
      'FileType',
      pattern = [[\v(javascript|typescript)(react|)]],
      callback = function()
        vim.b.switch_custom_definitions = {
          {
            [ [[\v'([^'`]+)']] ] = [[`\1`]],
            [ [[\v'([^'"]+)']] ] = [["\1"]],
            [ [[\v`([^`"]+)`]] ] = [["\1"]],
            [ [[\v`([^`']+)`]] ] = [['\1']],
            [ [[\v"([^"']+)"]] ] = [['\1']],
            [ [[\v"([^"`]+)"]] ] = [[`\1`]],
            [ [[\v^( *)(it|describe|test)( *)\(]] ] = [[\1\2.only\3(]],
            [ [[\v^( *)(it|describe|test).only( *)\(]] ] = [[\1\2.skip\3(]],
            [ [[\v^( *)(it|describe|test).skip( *)\(]] ] = [[\1\2\3(]],
          },
        }
      end,
    },
  },

  init = function()
    vim.g.switch_mapping = '-'
  end,
})

--------------------------------------------------------------------------------

layer.use({
  requires = {
    'axelvc/template-string.nvim',
  },

  setup = function()
    require('template-string').setup()
  end,
})

layer.use({
  requires = {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  },
})
