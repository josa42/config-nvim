vim.cmd.highlight({
  args = { 'link', 'GitSignsCurrentLineBlame', 'Comment' },
  bang = true,
})

return {
  {
    'lewis6991/gitsigns.nvim',

    events = { 'BufRead' },

    config = {
      yadm = { enable = true },
      signs = require('config.signs').gitsigns,
      current_line_blame = false,
      current_line_blame_opts = {
        ignore_whitespace = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      },
      preview_config = {
        border = 'single',
      },
    },
    keys = {
      {
        '<leader>gb',
        function()
          require('gitsigns').blame()
        end,
      },
    },
  },
}
