local layer = require('jg.lib.layer')

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
    'AndrewRadev/tagalong.vim', -- Keep html tags in sync
    'alvan/vim-closetag',
  },

  init = function()
    vim.g.tagalong_additional_filetypes = { 'javascript', 'template', 'html', 'js' }
    vim.g.closetag_filetypes = 'html,javascript,template'
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

layer.use({
  requires = { 'arthurxavierx/vim-caser' }, -- Change cases: gk
  init = function()
    -- g prefix
    vim.g.caser_prefix = 'gk'
  end,
})

--------------------------------------------------------------------------------
-- Motion actions

layer.use({
  requires = { 'josa42/nvim-actions' },
  setup = function()
    require('jg.actions').setup()
  end,
})

--------------------------------------------------------------------------------
-- Surround

layer.use({
  requires = { 'machakann/vim-sandwich' },
  setup = function()
    vim.cmd([[let sandwich#recipes = sandwich#default_recipes]])
    --
    vim.g['sandwich#recipes'] = vim.fn.extend(vim.fn.deepcopy(vim.g['sandwich#default_recipes'] or {}), {
      { buns = { 'act(() => {', '})' }, nesting = 1, input = { 'c' } },
      {
        buns = { 'act(() => {', '});' },
        motionwise = { 'line' },
        kind = { 'add' },
        linewise = 1,
        command = { "'[+1,']-1normal! >>" },
        input = { 'a' },
      },
      {
        buns = { 'await act(async () => {', '});' },
        motionwise = { 'line' },
        kind = { 'add' },
        linewise = 1,
        command = { "'[+1,']-1normal! >>" },
        input = { 'A' },
      },
      {
        buns = { 'act(() => {', '})' },
        motionwise = { 'line' },
        kind = { 'delete' },
        linewise = 1,
        command = { "'[,']normal! <<" },
        input = { 'a' },
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
-- automatically create nested directories for new files

layer.use({
  requires = { 'jghauser/mkdir.nvim' },
  setup = function()
    require('mkdir')
  end,
})
