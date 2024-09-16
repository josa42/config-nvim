return {
  {
    'josa42/theme-theonedark',

    name = 'theonedark',

    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. '/dist/nvim')

      vim.o.termguicolors = true
      vim.cmd.colorscheme('theonedark')
    end,
  },
}
