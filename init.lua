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

require('jg.layers.builtin-options')
require('jg.layers.builtin-keymaps')

-- Theme and syntax highlighting
require('jg.layers.theme')
require('jg.layers.syntax')

-- UI
require('jg.layers.tabline')
require('jg.layers.statusline')
require('jg.layers.indent-line')
require('jg.layers.scrolling')
require('jg.layers.ui')

-- Version Control
require('jg.layers.git')

-- Editing
require('jg.layers.lsp')
require('jg.layers.code-commands')
require('jg.layers.completion')
require('jg.layers.diagnostics')
require('jg.layers.editing')
require('jg.layers.comments')
require('jg.layers.textobjects')
require('jg.layers.snippets')
require('jg.layers.colors')
require('jg.layers.file-pairs')
require('jg.layers.spelling')
require('jg.layers.diagrams')
require('jg.layers.templates')
require('jg.layers.marks')

require('jg.layers.undo')

-- File Navigations
require('jg.layers.file-tree')
require('jg.layers.fuzzy-finder')
require('jg.layers.files')

-- config
require('jg.layers.config')

require('jg.layers.terminal')

-- nvim dev stuff
require('jg.layers.debug')

-- install plugins
require('jg.lib.layer').load()
