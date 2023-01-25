local layer = require('jg.lib.layer')

layer.use({
  enabled = not vim.fn.has('nvim-0.9'),
  requires = {
    'editorconfig/editorconfig-vim',
  },
})

layer.use({
  enabled = false and vim.fn.has('nvim-0.9'),
  setup = function()
    local function lang_exists(lang)
      local lang_without_region = vim.fn.split(lang, '_')[1]
      local languages =
        vim.tbl_map(vim.fs.basename, vim.fn.globpath(vim.api.nvim_eval('&runtimepath'), 'spell/*', 0, 1))

      local found = #vim.tbl_filter(function(l)
        return string.find(l, lang_without_region) == 1
      end, languages)

      return found > 0
    end

    require('editorconfig').properties.spell_language = function(bufnr, val)
      local lang = val:lower():gsub('-', '_')

      if lang_exists(lang) then
        vim.bo[bufnr].spelllang = lang
      end
    end
  end,
})
