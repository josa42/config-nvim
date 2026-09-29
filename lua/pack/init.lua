-- Plugin management via Neovim's built-in vim.pack.
--
-- Everything loads eagerly: vim.pack has no event/ft/cmd/keys equivalent, so
-- the lazy-loading keys in lua/plugins/*.lua are ignored here.

if vim.pack == nil then
  vim.notify('vim.pack is not available in this Neovim build', vim.log.levels.ERROR)
  return
end

-- Local plugins live in the config repo and are not managed by vim.pack, which
-- assumes exclusive ownership of its own directory.
for _, name in ipairs({ 'automkdir', 'autoread', 'git-commands', 'indent-lines', 'tmux' }) do
  vim.opt.rtp:append(vim.fs.joinpath(vim.fn.stdpath('config'), 'plugins', name))
end

-- Build steps, the lazy.nvim `build` key's replacement.
local builds = {
  ['nvim-treesitter'] = function()
    vim.cmd.packadd('nvim-treesitter')
    vim.cmd('TSUpdate')
  end,
  ['telescope-fzf-native.nvim'] = function(path)
    vim.system({ 'make' }, { cwd = path }):wait()
  end,
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack.build', { clear = true }),
  callback = function(ev)
    local build = builds[ev.data.spec.name]
    if build and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      build(ev.data.path)
    end
  end,
})

vim.pack.add(require('pack.plugins'), { load = true, confirm = false })

local errors = require('pack.setup').run()

if #errors > 0 then
  vim.schedule(function()
    vim.notify(('pack: %d plugin(s) failed\n%s'):format(#errors, table.concat(errors, '\n')), vim.log.levels.WARN)
  end)
end

vim.api.nvim_create_user_command('PackErrors', function()
  if #errors == 0 then
    vim.notify('No plugin errors')
    return
  end
  vim.notify(table.concat(errors, '\n'), vim.log.levels.WARN)
end, {})
