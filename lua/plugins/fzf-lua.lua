return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- calling `setup` is optional for customization
    require('fzf-lua').setup({
      -- 'telescope',
      -- fzf_opts = {
      --   ['--no-scrollbar'] = true,
      --   ['--bind'] = 'Ctrl-p:toggle-preview',
      -- },
      keymap = {
        builtin = {
          ['ctrl-p'] = 'toggle-preview',
        },
        fzf = {
          ['ctrl-p'] = 'toggle-preview',
        },
        actions = {
          ['ctrl-p'] = 'toggle-preview',
        },
      },
    })

    require('fzf-lua').register_ui_select()
  end,
}
