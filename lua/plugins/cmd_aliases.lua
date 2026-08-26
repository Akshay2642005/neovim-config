local STORE_PATH = vim.fn.stdpath('data') .. '/cmd_aliases.json'

local function load_aliases()
  local f = io.open(STORE_PATH, 'r')
  if not f then
    return {
      W = 'w', Q = 'q', Wq = 'wq', Qa = 'qa',
      WA = 'wa', WQ = 'wq',
    }
  end
  local content = f:read('*a')
  f:close()
  if content == '' then return {} end
  local ok, data = pcall(vim.json.decode, content)
  return ok and data or {}
end

local function save_aliases(aliases)
  local f = io.open(STORE_PATH, 'w')
  if not f then return end
  f:write(vim.json.encode(aliases))
  f:close()
end

local function apply_aliases()
  local aliases = load_aliases()
  for short, full in pairs(aliases) do
    vim.cmd(string.format('cnoreabbrev <expr> %s getcmdtype() == ":" && getcmdline() ==# "%s" ? "%s" : "%s"', short, short, full, short))
  end
end

local function add(short, full)
  local aliases = load_aliases()
  aliases[short] = full
  save_aliases(aliases)
  apply_aliases()
  vim.notify(string.format('Alias: %s → %s', short, full))
end

local function remove(short)
  local aliases = load_aliases()
  aliases[short] = nil
  save_aliases(aliases)
  apply_aliases()
  vim.notify(string.format('Removed alias: %s', short))
end

local function list()
  local aliases = load_aliases()
  local lines = { 'Command Aliases:', '' }
  local sorted = {}
  for short, full in pairs(aliases) do
    sorted[#sorted + 1] = { short = short, full = full }
  end
  table.sort(sorted, function(a, b) return a.short < b.short end)
  for _, a in ipairs(sorted) do
    lines[#lines + 1] = string.format('  %s → %s', a.short, a.full)
  end
  print(table.concat(lines, '\n'))
end

apply_aliases()

vim.api.nvim_create_user_command('Alias', function(opts)
  local parts = vim.split(opts.args, '%s+')
  if #parts < 2 then
    vim.notify('Usage: :Alias <short> <full>', vim.log.levels.WARN)
    return
  end
  add(parts[1], parts[2])
end, { nargs = '+' })

vim.api.nvim_create_user_command('Unalias', function(opts)
  remove(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command('AliasList', function()
  list()
end, {})
