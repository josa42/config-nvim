local M = {}

function M.try_mason_install(tools)
  local has_mason, mason = pcall(require, 'mason-registry')

  if has_mason then
    for _, tool in ipairs(tools) do
      local ok, pkg = pcall(mason.get_package, tool)
      if ok and not pkg:is_installed() and not pkg:is_installing() then
        pkg:install()
      end
    end
  end
end

return M
