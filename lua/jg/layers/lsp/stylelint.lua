local M = {}

function M.setup(setup)
  setup('stylelint_lsp', {
    filetypes = { 'css', 'less', 'scss' },
    settings = {
      stylelintplus = {
        autoFixOnFormat = true,
      },
    },
  })
end

return M
