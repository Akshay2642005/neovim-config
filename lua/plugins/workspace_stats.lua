local function shellescape(str)
  return "'" .. str:gsub("'", "'\\''") .. "'"
end

local function stats()
  local cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(cwd, ':t')

  local count_cmd = string.format(
    'find %s -type f \\( -name "*.lua" -o -name "*.js" -o -name "*.ts" -o -name "*.tsx" '
      .. '-o -name "*.jsx" -o -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.py" '
      .. '-o -name "*.rs" -o -name "*.go" -o -name "*.java" -o -name "*.md" -o -name "*.json" '
      .. '-o -name "*.yaml" -o -name "*.yml" -o -name "*.toml" -o -name "*.sh" -o -name "*.css" '
      .. '-o -name "*.html" -o -name "*.vim" \\) '
      .. '-not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/target/*" '
      .. '-not -path "*/dist/*" -not -path "*/build/*" 2>/dev/null | head -500',
    shellescape(cwd)
  )

  local handle = io.popen(count_cmd)
  if not handle then return end
  local files = handle:read('*a')
  handle:close()

  local file_list = {}
  for f in files:gmatch('[^\n]+') do
    if f ~= '' then file_list[#file_list + 1] = f end
  end

  local ext_count = {}
  local total_lines = 0
  local largest = { file = '', lines = 0 }

  for _, f in ipairs(file_list) do
    local ext = vim.fn.fnamemodify(f, ':e')
    if ext == '' then ext = 'other' end
    ext_count[ext] = (ext_count[ext] or 0) + 1

    local wc = vim.fn.system('wc -l < ' .. shellescape(f))
    local lines = tonumber(wc:match('%d+')) or 0
    total_lines = total_lines + lines

    if lines > largest.lines then
      largest = { file = vim.fn.fnamemodify(f, ':~:.'), lines = lines }
    end
  end

  local sorted_ext = {}
  for ext, count in pairs(ext_count) do
    sorted_ext[#sorted_ext + 1] = { ext = ext, count = count }
  end
  table.sort(sorted_ext, function(a, b) return a.count > b.count end)

  local ext_str = ''
  local shown = 0
  for _, e in ipairs(sorted_ext) do
    if shown >= 5 then break end
    ext_str = ext_str .. e.ext .. ': ' .. e.count .. ', '
    shown = shown + 1
  end
  ext_str = ext_str:gsub(', $', '')

  local lines = {
    'Project: ' .. project_name,
    '',
    string.format('  Files: %d (%s)', #file_list, ext_str),
    string.format('  Total lines: %s', tostring(total_lines)),
    '',
    '  Largest file:',
    string.format('    %s (%d lines)', largest.file, largest.lines),
  }

  vim.schedule(function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = 'text'

    local width = 0
    for _, l in ipairs(lines) do
      if #l > width then width = #l end
    end
    width = math.max(width + 4, 40)

    local height = #lines
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'single',
      title = ' Workspace Stats ',
      title_pos = 'center',
    })

    vim.keymap.set('n', 'q', function()
      vim.api.nvim_win_close(0, true)
    end, { buffer = buf })
  end)
end

return {
  name = 'workspace-stats',
  keys = {
    { '<leader>ws', stats, desc = 'Workspace stats' },
  },
}
