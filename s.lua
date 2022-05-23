-- https://github.com/mpeterv/markdown
local function read_file(path)
  local file = io.open(path, 'rb')

  if file then
    local content = file:read('*a')
    file:close()

    return content
  end

  return nil
end

local function create_server(host, port, on_connect)
  local server = vim.loop.new_tcp()
  server:bind(host, port)
  server:listen(128, function(err)
    assert(not err, err)

    local sock = vim.loop.new_tcp()
    server:accept(sock)
    on_connect(sock)
  end)
  return server
end

local function send(socket, content)
  socket:write('HTTP/1.0 200 OK\n')
  socket:write('Content-Type: text/html\n')
  socket:write('\n')
  socket:write(content)
  socket:close()
end

local function send_file(socket, file_path)
  send(socket, read_file(file_path))
end

local server = create_server('0.0.0.0', 8888, function(sock)
  sock:read_start(function(err, chunk)
    assert(not err, err)

    if string.match(chunk, '^GET /subscribe') then
      vim.defer_fn(function()
        send(sock, 'DONE')
      end, 5000)
    else
      send_file(sock, 's.html')
    end
  end)
end)

print('TCP echo-server listening on port: ' .. server:getsockname().port)
