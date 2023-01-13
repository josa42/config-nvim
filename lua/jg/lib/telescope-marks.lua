local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values

local home = os.getenv('HOME')

local replace_prefix = function(str, prefix, replace)
  if str:sub(1, prefix:len()) == prefix then
    return replace .. str:sub(prefix:len() + 1)
  end

  return str
end

local fmt_filename = function(name)
  name = replace_prefix(name, '~/', home .. '/')
  name = replace_prefix(name, os.getenv('PWD') .. '/', '')
  name = replace_prefix(name, home .. '/', '~/')

  return name
end

local fmt_line = function(m, name)
  return ('%s %6d    %s'):format(m.mark, m.lnum, name)
end

local M = {}

M.marks = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  local bufname = vim.api.nvim_buf_get_name(opts.bufnr)
  local create_mark = function(v)
    return {
      lnum = v.pos[2],
      col = v.pos[3],
      mark = v.mark:sub(2, 3),
      filename = v.file or bufname,
    }
  end

  local marks = {}

  for _, v in ipairs(vim.fn.getmarklist(opts.bufnr)) do
    if v.mark:match("^'[a-zA-Z]$") then
      local m = create_mark(v)
      m.line = fmt_line(m, vim.fn.trim(vim.api.nvim_buf_get_lines(opts.bufnr, m.lnum - 1, m.lnum, false)[1]))
      table.insert(marks, m)
    end
  end

  for _, v in ipairs(vim.fn.getmarklist()) do
    if v.mark:match("^'[a-zA-Z]$") then
      local m = create_mark(v)
      m.line = fmt_line(m, fmt_filename(vim.api.nvim_get_mark(m.mark, {})[4]))
      table.insert(marks, m)
    end
  end

  pickers
    .new(opts, {
      prompt_title = 'Marks',
      finder = finders.new_table({
        results = marks,
        entry_maker = opts.entry_maker or make_entry.gen_from_marks(opts),
      }),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      push_cursor_on_edit = true,
      push_tagstack_on_edit = true,
    })
    :find()
end

return M
