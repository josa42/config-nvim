return {
  'ActivityWatch/aw-watcher-vim',
  event = 'VeryLazy',
  config = function()
    vim.cmd.AWStart()
  end,
}
