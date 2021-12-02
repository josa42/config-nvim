--                                           _
--                                          (_)
--                     _ __   ___  _____   ___ _ __ ___
--                    | '_ \ / _ \/ _ \ \ / / | '_ ` _ \
--                    | | | |  __/ (_) \ V /| | | | | | |
--                    |_| |_|\___|\___/ \_/ |_|_| |_| |_|
--                                       __ _
--                          __ ___ _ _  / _(_)__ _
--                         / _/ _ \ ' \|  _| / _` |
--                         \__\___/_||_|_| |_\__, |
--                                           |___/
-- Layers ======================================================================

require('jg.layers.globals')

require('jg.layers.builtin-options')
require('jg.layers.builtin-keymaps')

-- Theme and syntax highlighting
require('jg.layers.theme')
require('jg.layers.syntax')
require('jg.layers.syntax--treesitter')

-- UI
require('jg.layers.tabline')
require('jg.layers.statusline')
require('jg.layers.indent-line')
require('jg.layers.scrolling')
-- require('jg.layers.scrollbar')

-- Version Control
require('jg.layers.git')

-- Language specific Settings
require('jg.layers.markdown')
require('jg.layers.yaml')
require('jg.layers.ansible')
require('jg.layers.go')

-- Editing
require('jg.layers.lsp')
require('jg.layers.editing')
require('jg.layers.comments')
require('jg.layers.textobjects')
require('jg.layers.snippets')
require('jg.layers.colors')
require('jg.layers.file-pairs')
-- require('jg.layers.copilot')

require('jg.layers.help')

-- File Navigations
require('jg.layers.file-tree')
require('jg.layers.fuzzy-finder--telescope')
require('jg.layers.search')
-- require('jg.layers.fuzzy-finder--fzf')

require('jg.layers.config')

-- Misc - TODO split these up
require('jg.layers.misc')

-- install plugins
require('jg.lib.layer').load()
