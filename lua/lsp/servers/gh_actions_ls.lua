return function()
  -- Get GitHub token for richer completions (action inputs, context suggestions)
  local token = vim.env.GITHUB_TOKEN or vim.fn.system('gh auth token 2>/dev/null'):gsub('%s+$', '')
  if token == '' then
    token = nil
  end

  return {
    cmd = { 'gh-actions-language-server', '--stdio' },
    filetypes = { 'yaml.github' },
    root_dir = function(bufnr, on_dir)
      on_dir(vim.fs.root(bufnr, '.github'))
    end,
    single_file_support = true,
    init_options = {
      sessionToken = token,
    },
    capabilities = {
      workspace = {
        didChangeWorkspaceFolders = {
          dynamicRegistration = true,
        },
      },
    },
  }
end
