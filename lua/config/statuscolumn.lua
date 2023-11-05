vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = 'yes'
vim.opt.foldcolumn = 'auto:5'

if vim.fn.exists('&statuscolumn') == 1 then
  vim.opt.statuscolumn = vim.fn.join({
    -- signs
    '%s',
    -- line number
    '%=%{&nu&&(!v:virtnum)? (&rnu&&(v:relnum) ? v:relnum : v:lnum." ") : ""} ',
    -- fold
    '%C%',
    -- space
    '#Normal#%{&nu? " " : ""}',
  }, '')
end
