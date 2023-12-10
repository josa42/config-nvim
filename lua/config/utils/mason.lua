local M = {}

function M.try_mason_install(tools)
  local has_mason, mason = pcall(require, 'mason-registry')

  if has_mason then
    for _, tool in ipairs(tools) do
      local pkg = mason.get_package(tool)
      if not pkg:is_installed() then
        pkg:install()
      end
    end
  end
end

return M
