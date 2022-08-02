local layer = require('jg.lib.layer')

layer.use({
  enabled = false,
  requires = {
    'klen/nvim-test',
  },
  map = {
    { 'n', '<c-t>', ':TestFile<cr>' },
  },
  setup = function()
    require('nvim-test').setup({
      --   termOpts = {
      --     direction = 'float',
      --   },
    })
  end,
})

layer.use({
  requires = {
    'nvim-neotest/neotest',
    'haydenmeade/neotest-jest',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'antoinemadec/FixCursorHold.nvim',
  },

  map = function()
    local neotest = require('neotest')
    local run = function()
      neotest.run.run(vim.fn.expand('%'))
    end

    return {
      { 'n', '<c-t><c-t>', run },
      { 'n', '<c-t>s', neotest.summary.open },
      { 'n', '<c-t>o', neotest.output.open },
    }
  end,

  setup = function()
    require('neotest').setup({
      icons = {
        passed = '✔',
        running = '累',
        skipped = 'ﰸ',
        unknown = '?',
      },

      adapters = {
        require('neotest-jest')({
          jestCommand = './node_modules/.bin/jest',
        }),
      },
    })

    -- vim.cmd([[
    --   hi default NeotestPassed ctermfg=Green guifg=#96F291
    --   hi default NeotestFailed ctermfg=Red guifg=#F70067
    --   hi default NeotestRunning ctermfg=Yellow guifg=#FFEC63
    --   hi default NeotestSkipped ctermfg=Cyan guifg=#00f1f5
    --   hi default link NeotestTest Normal
    --   hi default NeotestNamespace ctermfg=Magenta guifg=#D484FF
    --   hi default NeotestFocused gui=bold,underline cterm=bold,underline
    --   hi default NeotestFile ctermfg=Cyan guifg=#00f1f5
    --   hi default NeotestDir ctermfg=Cyan guifg=#00f1f5
    --   hi default NeotestIndent ctermfg=Grey guifg=#8B8B8B
    --   hi default NeotestExpandMarker ctermfg=Grey guifg=#8094b4
    --   hi default NeotestAdapterName ctermfg=Red guifg=#F70067
    --   hi default NeotestWinSelect ctermfg=Cyan guifg=#00f1f5 gui=bold
    --   hi default NeotestMarked ctermfg=Brown guifg=#F79000 gui=bold
    --   hi default NeotestTarget ctermfg=Red guifg=#F70067
    --   hi default link NeotestUnknown Normal
    -- ]])
  end,
})
