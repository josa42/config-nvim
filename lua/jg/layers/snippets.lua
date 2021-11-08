if __flags.snippets ~= 'vsnip' then return end

local plug = require('jg.lib.plug')
local paths = require('jg.lib.paths')

plug.require('hrsh7th/vim-vsnip')

vim.g.vsnip_snippet_dir = paths.configHome .. '/vsnip'
