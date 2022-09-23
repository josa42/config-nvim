local M = {}

M.home = os.getenv('HOME')

M.data_home = os.getenv('XDG_DATA_HOME') or M.home .. '/.local/share'
M.data_dir = M.data_home .. '/nvim'

M.config_home = os.getenv('XDG_CONFIG_HOME') or M.home .. '/.config'
M.config_dir = M.config_home .. '/nvim'

M.lsp_bin = os.getenv('NVIM_TOOLS_BIN') or M.data_home .. '/nvim-tools/bin'

return M
