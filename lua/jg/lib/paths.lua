local M = {}

M.home = os.getenv("HOME")

M.dataHome = os.getenv("XDG_DATA_HOME") or M.home .. '/.local/share'
M.dataDir = M.dataHome .. '/nvim'

M.configHome = os.getenv("XDG_CONFIG_HOME") or M.home .. '/.config'
M.configDir = M.configHome .. '/nvim'

M.lspBin = M.dataHome .. '/nvim-tools/bin'

return M
