local plug = require('jg.lib.plug')
local au = require('jg.lib.autocmd')
local map = vim.api.nvim_set_keymap
local bmap = vim.api.nvim_buf_set_keymap

plug.require('tpope/vim-repeat')

local layer = require('jg.lib.layer')

--------------------------------------------------------------------------------

layer.use({
  require = { 'AndrewRadev/splitjoin.vim' },
})
--------------------------------------------------------------------------------

layer.use({
  require = { 'AndrewRadev/sideways.vim' },
  map = {
    { 'n', 'g<left>', ':SidewaysLeft<cr>' },
    { 'n', 'g<right>', ':SidewaysRight<cr>' },
  },
})

--------------------------------------------------------------------------------
layer.use({
  require = { 'windwp/nvim-autopairs' },
  after = function()
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
  require = {
    'AndrewRadev/tagalong.vim', -- Keep html tags in sync
    'alvan/vim-closetag',
  },

  before = function()
    vim.g.tagalong_additional_filetypes = { 'javascript', 'template', 'html', 'js' }
    vim.g.closetag_filetypes = 'html,javascript,template'
  end,
})

--------------------------------------------------------------------------------
-- Aligning
layer.use({
  require = { 'junegunn/vim-easy-align' }, -- Column align: ga
  map = {
    -- Start interactive EasyAlign in visual mode (e.g. vipga)
    { 'x', 'ga', '<Plug>(EasyAlign)' },
    -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
    { 'n', 'ga', '<Plug>(EasyAlign)' },
  },
})
--------------------------------------------------------------------------------
layer.use({
  require = { 'arthurxavierx/vim-caser' }, -- Change cases: gs
  before = function()
    -- g prefix
    vim.g.caser_prefix = 'gk'
  end,
})

--------------------------------------------------------------------------------
-- Sorting
layer.use({
  require = { 'christoomey/vim-sort-motion' },
})

--------------------------------------------------------------------------------
-- Surround
layer.use({
  require = { 'machakann/vim-sandwich' },
  after = function()
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
  require = { 'AndrewRadev/switch.vim' },

  before = function()
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
  require = { 'jghauser/mkdir.nvim' },
  after = function()
    require('mkdir')
  end,
})
