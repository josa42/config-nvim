vim.api.nvim_create_user_command('GitBrowse', function(opts)
  local function sh(cmd, dir)
    if dir then
      return vim.fn.trim(vim.fn.system(('cd "%s"; %s'):format(dir, cmd)))
    end
    return vim.fn.trim(vim.fn.system(cmd))
  end

  local abs_path = vim.fn.expand('%:p')
  local abs_dir = vim.fn.expand('%:p:h')
  if abs_path == '' then
    vim.notify('File not found')
    return
  end

  local root = sh('git rev-parse --show-toplevel', abs_dir)

  local rel_path = sh(('git ls-files --full-name -- %s'):format(abs_path), abs_dir)
  if rel_path == '' then
    vim.notify('File not found')
    return
  end

  if opts.bang then
    local branch = sh('git symbolic-ref refs/remotes/origin/HEAD --short', root):gsub('^origin/', '')
    sh(('gh browse %s --branch %s'):format(rel_path, branch), root)
  else
    local branch = sh('git branch --show-current', root)
    sh(('gh browse %s --branch %s'):format(rel_path, branch), root)
  end
end, { bang = true })

vim.api.nvim_create_user_command('GitReset', function()
  vim.fn.system('git checkout HEAD -- ' .. vim.fn.expand('%'))
  vim.cmd.edit({ bang = true })
end, {
  nargs = 0,
})
