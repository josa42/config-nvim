local plug = require('jg.lib.plug')
local au = require('jg.lib.autocmd')

plug.require('tpope/vim-repeat')

local layer = require('jg.lib.layer')

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

  init = function()
    vim.g.switch_mapping = '-'

    au.group('switch_custom_definitions', function(cmd)
      cmd({ on = 'FileType' }, function()
        vim.g.switch_custom_definitions = {}
      end)

      cmd({ on = 'FileType', pattern = [[\v(javascript|typescript)(react|)]] }, function()
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
      end)
    end)
  end,
})

layer.use({
  requires = { 'jghauser/mkdir.nvim' },
  setup = function()
    require('mkdir')
  end,
})
