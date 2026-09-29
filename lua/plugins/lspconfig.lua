-- Most entries in lua/lsp/servers/ supply only `settings` and inherit their
-- `cmd` from the lsp/<name>.lua files nvim-lspconfig ships. Those are resolved
-- off the runtimepath, so lspconfig has to be loaded before config.lsp enables
-- anything -- otherwise every such server fails validation with
-- "cmd: expected function or table with executable command, got nil".
return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
  },
}
