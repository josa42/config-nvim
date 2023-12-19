function local_plugin(name)
  return vim.fn.stdpath('config') .. '/plugins/' .. name
end

return {
  { 'josa42/nvim-automkdir', dir = local_plugin('automkdir') },
  { 'josa42/nvim-autoread', dir = local_plugin('autoread') },
}
