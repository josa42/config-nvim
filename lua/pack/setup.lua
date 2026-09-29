-- Runs the opts/config half of the plugin specs.
--
-- vim.pack installs plugins and puts them on the runtimepath; it has no opinion
-- about calling setup(). This walks the existing specs in lua/plugins and does
-- what lazy.nvim would have done, minus every lazy-loading key.

local M = {}

local pack_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site/pack/core/opt')

-- Guess the module holding setup(), the way lazy.nvim does:
-- gitsigns.nvim -> gitsigns, copilot.lua -> copilot,
-- homeassistant-nvim -> homeassistant, markdown-preview.nvim -> markdown_preview.
local function candidate_names(name)
  local bases, seen, out = {}, {}, {}

  local function base(n)
    if n ~= '' and not vim.tbl_contains(bases, n) then
      table.insert(bases, n)
    end
  end

  base(name)
  base((name:gsub('%.nvim$', '')))
  base((name:gsub('%.vim$', '')))
  base((name:gsub('%.lua$', '')))
  base((name:gsub('%-nvim$', '')))
  base((name:gsub('%-vim$', '')))
  base((name:gsub('^nvim%-', '')))
  base((name:gsub('^vim%-', '')))

  -- Repos hyphenate where the module underscores.
  for _, b in ipairs(vim.deepcopy(bases)) do
    base((b:gsub('%-', '_')))
  end

  for _, b in ipairs(bases) do
    if not seen[b] then
      seen[b] = true
      table.insert(out, b)
    end
  end

  return out
end

-- Returns the first requireable module exposing setup().
local function main_module(name)
  for _, candidate in ipairs(candidate_names(name)) do
    local ok, mod = pcall(require, candidate)
    if ok and type(mod) == 'table' and type(mod.setup) == 'function' then
      return mod
    end
  end
end

local function plugin_stub(spec)
  local name = spec.name or (spec[1] and spec[1]:match('[^/]+$'))
  return {
    name = name,
    dir = spec.dir or vim.fs.joinpath(pack_dir, name or ''),
  }
end

-- opts may be a table or a function(plugin, opts); config may be a function
-- (plugin, opts) or, historically, a table of opts.
local function resolve_opts(spec, plugin)
  local opts = spec.opts
  if type(opts) == 'function' then
    opts = opts(plugin, {})
  end
  if opts == nil and type(spec.config) == 'table' then
    opts = spec.config
  end
  return opts or {}
end

-- lazy.nvim's `keys` entries double as lazy-load triggers. With everything
-- eager they are just keymaps, so register them directly. Entries that are a
-- bare lhs with no rhs were pure triggers and have nothing to bind.
local function set_keys(spec, plugin, errors)
  local keys = spec.keys
  if type(keys) == 'function' then
    local ok, result = pcall(keys)
    if not ok then
      table.insert(errors, ('%s keys: %s'):format(plugin.name, result))
      return
    end
    keys = result
  end

  if type(keys) ~= 'table' then
    return
  end

  -- A single key spec rather than a list of them.
  if type(keys[1]) == 'string' then
    keys = { keys }
  end

  for _, key in ipairs(keys) do
    local lhs, rhs = key[1], key[2]
    if type(lhs) == 'string' and rhs ~= nil then
      local ok, err = pcall(vim.keymap.set, key.mode or 'n', lhs, rhs, {
        desc = key.desc,
        silent = key.silent,
        expr = key.expr,
      })
      if not ok then
        table.insert(errors, ('%s keymap %s: %s'):format(plugin.name, lhs, err))
      end
    end
  end
end

local function configure(spec, errors)
  if spec.enabled == false then
    return
  end

  local plugin = plugin_stub(spec)

  if type(spec.init) == 'function' then
    local ok, err = pcall(spec.init, plugin)
    if not ok then
      table.insert(errors, ('%s init: %s'):format(plugin.name, err))
    end
  end

  set_keys(spec, plugin, errors)

  local opts = resolve_opts(spec, plugin)

  if type(spec.config) == 'function' then
    local ok, err = pcall(spec.config, plugin, opts)
    if not ok then
      table.insert(errors, ('%s config: %s'):format(plugin.name, err))
    end
  elseif spec.opts ~= nil or type(spec.config) == 'table' then
    local mod = main_module(plugin.name)
    if mod then
      local ok, err = pcall(mod.setup, opts)
      if not ok then
        table.insert(errors, ('%s setup: %s'):format(plugin.name, err))
      end
    elseif next(opts) ~= nil then
      -- Only worth reporting when opts would have been lost.
      table.insert(errors, ('%s: no setup() found for opts'):format(plugin.name))
    end
  end
end

-- Specs nest: a spec's dependencies may themselves be full specs.
local function walk(spec, errors)
  if type(spec) ~= 'table' then
    return
  end

  -- A list of specs rather than a spec itself.
  if spec[1] == nil or type(spec[1]) == 'table' then
    for _, child in ipairs(spec) do
      walk(child, errors)
    end
    return
  end

  for _, dep in ipairs(spec.dependencies or {}) do
    walk(dep, errors)
  end

  configure(spec, errors)
end

-- Specs are otherwise configured in alphabetical order. These have to come
-- first: mason prepends its bin directory to PATH, and plugins that look for a
-- mason-installed executable during setup will not find it before that runs.
local first = { 'mason' }

function M.run()
  local errors = {}
  local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua/plugins')

  local rest = {}
  for name, type_ in vim.fs.dir(dir) do
    if type_ == 'file' and name:match('%.lua$') then
      local mod = (name:gsub('%.lua$', ''))
      if not vim.tbl_contains(first, mod) then
        table.insert(rest, mod)
      end
    end
  end
  table.sort(rest)

  local names = vim.list_extend(vim.deepcopy(first), rest)

  for _, name in ipairs(names) do
    local ok, spec = pcall(require, 'plugins.' .. name)
    if ok then
      walk(spec, errors)
    else
      table.insert(errors, ('plugins.%s: %s'):format(name, spec))
    end
  end

  return errors
end

return M
