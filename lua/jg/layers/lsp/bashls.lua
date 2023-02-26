require('jg.lib.polyfills')

local settings = {}

return function()
  return {
    settings = settings,
    filetypes = { 'sh', 'zsh' },
    cmd_env = {
      GLOB_PATTERN = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command|.zsh)',
    },
  }
end
