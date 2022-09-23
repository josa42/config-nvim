if type(vim.api.nvim_create_augroup) ~= 'function' then
  error('nvim_create_augroup polyfill has been removed')
end

if type(vim.api.nvim_create_autocmd) ~= 'function' then
  error('nvim_create_autocmd polyfill has been removed')
end

if type(vim.api.nvim_create_user_command) ~= 'function' then
  error('nvim_create_user_command polyfill has been removed')
end
