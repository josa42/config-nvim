require('jg.lib.polyfills')

local paths = require('jg.lib.paths')
local layer = require('jg.lib.layer')

-- TODO split these up!

layer.use({
  init = function()
    vim.opt.number = true
    vim.opt.showmode = false
    vim.opt.cmdheight = 1
    vim.opt.signcolumn = 'yes'

    vim.opt.cursorline = true

    -- White space
    vim.opt.list = true
    vim.opt.listchars = {
      -- eol = '↲',
      tab = '» ',
      extends = '›',
      precedes = '‹',
      nbsp = '·',
      space = '·',
      trail = '·',
    }

    vim.opt.mouse = 'a'

    vim.opt.guifont = 'DejaVuSansMono Nerd Font:h12'

    -- Do not write .swp files
    vim.opt.backup = false
    vim.opt.swapfile = false

    -- Persistent undo
    vim.opt.undodir = paths.data_dir .. '/undo'
    vim.opt.undofile = true

    vim.opt.conceallevel = 2
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'json' },
      callback = function()
        vim.wo.conceallevel = 0
      end,
    })

    vim.opt.updatetime = 300 -- Smaller updatetime for CursorHold & CursorHoldI
    vim.opt.hidden = true -- if hidden is not set, TextEdit might fail.

    --Splits
    vim.opt.splitbelow = true
    vim.opt.splitright = true

    -- folds
    vim.opt.foldmethod = 'marker'
    vim.opt.foldenable = true

    vim.opt.autochdir = false

    -- Scroll offset
    vim.opt.scrolloff = 2

    -- pum
    vim.opt.pumblend = 0
    vim.opt.pumheight = 12
    vim.opt.wildoptions = 'pum'
    vim.opt.shortmess:append('c') -- don't give |ins-completion-menu| messages.

    vim.g.nerdfont = true

    -- split
    pcall(function()
      vim.opt.splitkeep = 'topline'
    end)
  end,
})

layer.use({
  name = 'indent',

  requires = {
    'Darazaki/indent-o-matic',
  },

  init = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
    vim.opt.wrap = false
    vim.opt.linebreak = true
  end,

  setup = function()
    require('indent-o-matic').setup({
      standard_widths = { 2, 4 },

      filetype_yaml = {
        standard_widths = { 2, 4 },
      },
    })
  end,

  commands = {
    Indent = {
      function(evt)
        local indent = tonumber(evt.fargs[1])

        vim.opt.tabstop = indent
        vim.opt.shiftwidth = indent
        vim.opt.expandtab = true

        if evt.bang then
          vim.cmd.normal({ 'mzggVG=`z', bang = true })
        end
      end,
      nargs = 1,
      bang = true,
      bar = true,
    },
  },

  autocmds = {
    {
      'FileType',
      pattern = 'markdown',
      callback = function()
        vim.wo.wrap = true
      end,
    },
  },
})

layer.use({
  name = 'search',

  init = function()
    vim.opt.hlsearch = true -- Highlight search results.
    vim.opt.ignorecase = false -- Make searching case insensitive
    vim.opt.smartcase = true -- ... unless the query has capital letters.
    vim.opt.gdefault = true -- Use 'g' flag by default with :s/foo/bar/.
    vim.opt.magic = true -- Use 'magic' patterns (extended regular expressions).

    vim.opt.incsearch = true -- Incremental search.
    vim.opt.inccommand = 'split'

    vim.opt.wildignore = {
      '.sass-cache',
      '.DS_Store',
      '.git$',
      '~$',
      '.swp$',
      'gin-bin',
      '*/node_modules/*',
    }
  end,
})

layer.use({
  name = 'autoread',

  init = function()
    vim.opt.autoread = true
  end,

  autocmds = {
    { { 'FocusGained', 'BufEnter' }, command = 'silent! !' },
    -- save on focus lost!
    { { 'FocusLost', 'WinLeave' }, command = 'silent! update' },
    -- ignore removed files
    { { 'FileChangedShell' }, command = 'execute' },
  },
})

layer.use({
  name = 'clipboard',

  init = function()
    vim.opt.clipboard = { 'unnamedplus' }
  end,

  autocmds = {
    {
      { 'BufWrite', 'InsertLeave' },
      callback = function()
        vim.opt.paste = false
      end,
    },
    {
      'TextYankPost',
      callback = function()
        vim.highlight.on_yank()
      end,
    },
  },
})
