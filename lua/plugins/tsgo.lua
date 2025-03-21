return {
  {
    enabled = false,
    'josa42/nvim-tsgo',
    opts = {
      tsgo_bin = os.getenv('HOME') .. '/github/microsoft/typescript-go/built/local/tsgo',
    },
  },
}
