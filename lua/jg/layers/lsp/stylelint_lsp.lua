return function(setup)
  setup('stylelint_lsp', {
    filetypes = { 'css', 'less', 'scss' },
    settings = {
      stylelintplus = {
        autoFixOnFormat = true,
      },
    },
  })
end
