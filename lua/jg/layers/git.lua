local layer = require('jg.lib.layer')
local hi = require('jg.lib.highlight')
local command = require('jg.lib.command')

layer.use({
  require = {
    'tpope/vim-fugitive', -- Git commands; mainly Gblame
    'tpope/vim-rhubarb',
    'tpope/vim-git',
    'rhysd/conflict-marker.vim',
    'sindrets/diffview.nvim',
    'mhinz/vim-signify',
  },

  before = function()
    -- reset file
    command.define('ResetFile', { nargs = 0 }, 'silent !git checkout HEAD -- %')

    -- Open Fork (git client)
    command.define('F', {}, 'silent! !fork')
    command.define('Ff', {}, 'silent! !fork log -- %')
    command.define('Fl', {}, 'silent! !fork log')
    command.define('Fs', {}, 'silent! !fork status')

    hi.set('ConflictMarkerBegin', { bg = '#2f7366' })
    hi.set('ConflictMarkerOurs', { bg = '#2e5049' })
    hi.set('ConflictMarkerTheirs', { bg = '#344f69' })
    hi.set('ConflictMarkerEnd', { bg = '#2f628e' })
    hi.set('ConflictMarkerCommonAncestorsHunk', { bg = '#754a81' })

    -- Git gutter
    vim.g.signify_realtime = 1
    vim.g.signify_sign_show_count = 0
    vim.g.signify_priority = 8

    vim.g.signify_sign_add = _G.__icons.vcs.add
    vim.g.signify_sign_delete = _G.__icons.vcs.delete_top
    vim.g.signify_sign_delete_first_line = _G.__icons.vcs.delete
    vim.g.signify_sign_change = _G.__icons.vcs.change
    vim.g.signify_sign_changedelete = _G.__icons.vcs.change_delete

    vim.cmd([[ nmap <leader>gj <plug>(signify-next-hunk) ]])
    vim.cmd([[ nmap <leader>gk <plug>(signify-prev-hunk) ]])
  end,
})
