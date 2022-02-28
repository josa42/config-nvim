local M = {}

local function get_on_read(results)
  return function(err, chunk)
    if err then
      print(err)
    end
    if chunk then
      for line in chunk:gmatch('[^\r\n]+') do
        table.insert(results, line)
      end
    end
  end
end

local function set_quickfix(results)
  vim.fn.setqflist({}, 'r', { title = 'Search Results', lines = results })
  vim.cmd('cwindow')
  if #results > 0 then
    vim.cmd('cfirst')
    vim.cmd('copen')
  end
end

local function run(cmd, args, process)
  local results = {}
  local handle

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  handle = vim.loop.spawn(
    cmd,
    { args = args, stdio = { stdout, stderr } },
    vim.schedule_wrap(function()
      stdout:read_stop()
      stderr:read_stop()

      stdout:close()
      stderr:close()

      handle:close()

      if process ~= nil then
        for i, line in ipairs(results) do
          results[i] = process(line)
        end
      end

      set_quickfix(results)
    end)
  )

  local on_read = get_on_read(results)

  vim.loop.read_start(stdout, on_read)
  vim.loop.read_start(stderr, on_read)
end

function M.rg(pattern, dir)
  run('rg', { '--regexp', pattern, dir or '.', '--vimgrep', '--smart-case' })
end

function M.fd(pattern, dir)
  run('fd', { '--regex', pattern, '--type', 'file', '--search-path', dir or '.' }, function(line)
    return line .. ':' .. 1 .. ': ' -- line .. line:gsub('^.*/', '')
  end)
end

function M.format(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fname_fmt1, fname_fmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local valid_fmt = '%s │%5d:%-3d│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fname_fmt1:format(fname)
        else
          fname = fname_fmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = valid_fmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

return M
