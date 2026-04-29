return function()
  return {
    cmd = { 'docker-language-server', 'start', '--stdio' },
    filetypes = { 'dockerfile', 'yaml.docker-compose' },
    root_dir = function(bufnr, on_dir)
      local name = vim.api.nvim_buf_get_name(bufnr)
      local markers = { 'Dockerfile', 'docker-compose.yml', 'docker-compose.yaml', 'compose.yml', 'compose.yaml', 'docker-bake.hcl' }
      local dir = vim.fs.find(markers, { path = name, upward = true })[1]
      on_dir(dir and vim.fs.dirname(dir) or vim.fn.getcwd())
    end,
    init_options = {
      dockerfileExperimental = { removeOverlappingIssues = true },
    },
  }
end
