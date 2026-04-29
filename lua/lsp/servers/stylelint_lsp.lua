return function()
  return {
    cmd = { 'stylelint-language-server', '--stdio' },
    filetypes = { 'css', 'less', 'scss' },
    settings = {
      stylelint = {
        validate = { 'css', 'less', 'scss' },
      },
    },
  }
end
