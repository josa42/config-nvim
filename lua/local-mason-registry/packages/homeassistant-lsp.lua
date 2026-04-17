-- /Users/josa/.config/nvim/lua/local-mason-registry/packages/homeassistant-lsp.lua

return {
  name = 'homeassistant-lsp',
  description = 'Home Assistant Language Server',
  homepage = 'https://github.com/myakove/homeassistant-lsp',
  licenses = { 'MIT' },
  languages = { 'yaml' },
  categories = { 'LSP' },
  source = {
    -- TODO set specific version
    id = 'pkg:npm/homeassistant-lsp@latest',
  },
  bin = {
    ['homeassistant-lsp'] = 'npm:homeassistant-lsp',
  },
}
