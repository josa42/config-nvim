local settings = {
  bashIde = {
    shellcheckPath = '',
    globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command|.zsh)',
  },
}

return function()
  return {
    settings = settings,
    filetypes = { 'sh', 'zsh' },
  }
end
