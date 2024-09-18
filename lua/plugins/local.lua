function local_plugin(name)
  return vim.fn.stdpath('config') .. '/plugins/' .. name
end

return {
  { 'josa42/nvim-automkdir', dir = local_plugin('automkdir') },
  { 'josa42/nvim-autoread', dir = local_plugin('autoread') },
  { 'josa42/nvim-indent-lines', dir = local_plugin('indent-lines'), opts = {} },
  { 'josa42/nvim-git-commands', dir = local_plugin('git-commands'), opts = {} },
  {
    'josa42/nvim-tmux',
    dir = local_plugin('tmux'),
    keys = {
      {
        '<leader>g',
        function()
          require('tmux').lazygit_file()
        end,
        mode = 'n',
      },
    },
  },
}
