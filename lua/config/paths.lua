local M = {}

local appName = os.getenv('NVIM_APPNAME') or 'nvim'

M.home = os.getenv('HOME')

M.data_home = os.getenv('XDG_DATA_HOME') or M.home .. '/.local/share'
M.data_dir = M.data_home .. '/' .. appName

M.config_home = os.getenv('XDG_CONFIG_HOME') or M.home .. '/.config'
M.config_dir = M.config_home .. '/' .. appName

M.lsp_bin = os.getenv('NVIM_TOOLS_BIN') or M.data_home .. '/nvim-tools/bin'

return M
