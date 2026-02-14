local M = {}

--- @param filename string
--- @param text string
function M.write_file(filename, text)
  local file = io.open(filename, 'w+')
  if file == nil or io.type(file) ~= 'file' then
    print('Failed to open output file', filename)
    return
  end
  file:setvbuf 'full'

  file:write(text)
  file:flush()
  file:close()
end

--- @return boolean
function M.running_wsl()
  local release = vim.uv.os_uname().release
  return string.find(release, 'WSL', 1, true) ~= nil
end

--- @return boolean
function M.running_android()
  local machine = vim.uv.os_uname().machine
  return string.find(machine, 'arm', 1, true) ~= nil
end

--- @return boolean
function M.is_nil_or_empty_string(s)
  return s == nil or s == ''
end

--- @return boolean
function M.is_unsaved()
  return vim.api.nvim_get_option_value('mod', { buf = 0 })
end

--- @return string
function M.trim(str)
  str = str:gsub('^%s+', '')
  str = str:gsub('%s+$', '')
  return str
end

--- @return boolean
function M.pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

--- Floating selector used by vim.ui.select and others
--- @param items table
--- @param opts table|nil
--- @param on_choice fun(item:any)
function M.floating_select(items, opts, on_choice)
  opts = opts or {}

  if not items or vim.tbl_isempty(items) then
    on_choice(nil)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.5)

  local max_height = math.floor(vim.o.lines * 0.4)
  local height = math.min(#items, max_height)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'single', -- Lazy-style
    title = opts.prompt or '',
    title_pos = 'center',
  })

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].modifiable = true
  vim.bo[buf].bufhidden = 'wipe'

  local lines = {}
  local pad = #tostring(#items)

  for i, item in ipairs(items) do
    local text = opts.format_item and opts.format_item(item) or tostring(item)
    lines[i] = string.format("%" .. pad .. "d. %s", i, text)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set('n', '<Esc>', close, { buffer = buf })
  vim.keymap.set('n', 'q', close, { buffer = buf })
  vim.keymap.set('n', '<CR>', function()
    local idx = vim.fn.line('.')
    close()
    on_choice(items[idx])
  end, { buffer = buf })
end

vim.ui.select = function(items, opts, on_choice)
  M.floating_select(items, opts, on_choice)
end

--- Open persistence.nvim session picker
function M.select_session()
  local ok, persistence = pcall(require, 'persistence')
  if not ok then
    vim.notify('persistence.nvim not found', vim.log.levels.ERROR)
    return
  end

  local sessions = persistence.list()
  if vim.tbl_isempty(sessions) then
    vim.notify('No sessions found', vim.log.levels.INFO)
    return
  end

  M.floating_select(sessions, {
    prompt = 'Sessions',
    format_item = function(session)
      return session.name
    end,
  }, function(session)
    if session then
      persistence.load({ session = session })
    end
  end)
end

function M.reload_config()
  local config = vim.fn.stdpath("config") .. "/init.lua"
  vim.cmd("source " .. config)
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end

return M
