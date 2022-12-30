local layer = require('jg.lib.layer')
layer.use({
  requires = {
    -- Files
    'tpope/vim-eunuch',
  },
})

--------------------------------------------------------------------------------
-- automatically create nested directories for new files

layer.use({
  setup = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, 'p')
        end
      end,
    })
  end,
})

--------------------------------------------------------------------------------
-- cycle through files in same directory

layer.use({

  map = function()
    local function open_next(dir)
      return function()
        local dir_path = vim.fn.expand('%:p:h')
        local file = vim.fn.expand('%:p')

        local dir_files = vim.tbl_filter(function(dir_file)
          return dir_file ~= '' and vim.fn.isdirectory(dir_file) == 0
        end, vim.split(vim.fn.glob(('%s/*'):format(dir_path)), '\n'))

        for idx, dir_file in ipairs(dir_files) do
          if dir_file == file then
            return vim.cmd.edit(dir_files[((idx - 1 + dir) % #dir_files) + 1])
          end
        end
      end
    end

    return {
      { 'n', '<leader>dj', open_next(1) },
      { 'n', '<leader>dk', open_next(-1) },
    }
  end,
})
