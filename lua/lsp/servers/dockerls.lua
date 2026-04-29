return function()
  return {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' },
    root_dir = function(bufnr, on_dir)
      local name = vim.api.nvim_buf_get_name(bufnr)
      local dir = vim.fs.find({ 'Dockerfile' }, { path = name, upward = true })[1]
      on_dir(dir and vim.fs.dirname(dir) or vim.fn.getcwd())
    end,
    settings = {
      docker = {
        languageserver = {},
      },
    },
  }
end
