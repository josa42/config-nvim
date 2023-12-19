local M = {}

function M.setup(opts)
  opts = opts or {}
  local ignore = opts.ignore or { 'qf' }

  -- White space
  vim.opt.list = true
  local lead_char = '┊'
  vim.opt.listchars = {
    -- eol = '↲',
    -- eol = '↴',
    tab = '┊ »',
    extends = '›',
    precedes = '‹',
    -- nbsp = '·',
    space = '·',
    -- trail = '·',
  }

  local function update_lead()
    local lcs = vim.opt_local.listchars:get()
    local lead = lead_char .. string.rep(lcs.space or ' ', vim.bo.shiftwidth - 1)

    if vim.tbl_contains(ignore, vim.bo.filetype) then
      vim.opt_local.listchars:append({
        space = ' ',
      })
    else
      vim.opt_local.listchars:append({
        -- leadmultispace = lead,
        multispace = lead,
      })
    end
  end
  vim.api.nvim_create_autocmd(
    'OptionSet',
    { pattern = { 'listchars', 'shiftwidth', 'filetype' }, callback = update_lead }
  )
  vim.api.nvim_create_autocmd({ 'VimEnter', 'BufReadPost' }, { callback = update_lead, once = true })
end

return M
