local au = require('jg.lib.autocmd')

local settings = {
  gopls = {
    codelenses = { vendor = false },
    analyses = { bools = true },
  },
}

local function buf_organize_imports()
  local params = vim.lsp.util.make_range_params()
  params.context = { source = { organizeImports = true } }

  local resp = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
  if resp and resp[1] and resp[1].result and resp[1].result[1] then
    vim.lsp.util.apply_workspace_edit(resp[1].result[1].edit)
  end
end

local function buf_formatting()
  buf_organize_imports()
  vim.lsp.buf.formatting()
end

return function()
  au.group('jg.lsp.go.autoformat', function(cmd)
    cmd({ on = { 'BufWritePre' }, pattern = '*.go' }, buf_formatting)
    cmd({ on = { 'InsertLeave' }, pattern = '*.go' }, vim.lsp.buf.formatting)
  end)

  return {
    settings = settings,
  }
end
