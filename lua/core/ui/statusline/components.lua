local M = {}

local MAX_LSP_NAMES = 3

function M.lsp_active()
  if not rawget(vim, 'lsp') then
    return ''
  end
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local names = {}
  for _, client in ipairs(clients) do
    if client.name ~= 'copilot' then
      table.insert(names, client.name)
    end
  end

  if #names == 0 then
    return ''
  end

  local label
  if #names > MAX_LSP_NAMES then
    label = table.concat(names, ', ', 1, MAX_LSP_NAMES)
      .. string.format(' +%d', #names - MAX_LSP_NAMES)
  else
    label = table.concat(names, ', ')
  end

  return string.format('%%#StatusLineMedium# LSP [%s] %%*', label)
end

function M.macro()
  local reg = vim.fn.reg_recording()
  if reg == '' then
    return ''
  end
  return string.format('%%#StatusLineLspError# REC @%s%%*', reg)
end

function M.git_branch()
  local gsd = vim.b.gitsigns_status_dict
  if not gsd or not gsd.head or gsd.head == '' then
    return ''
  end

  return string.format('%%#StatusLineMedium# %s %%*', gsd.head)
end

function M.grapple_tag()
  local ok, grapple = pcall(require, 'grapple')
  if not ok then
    return ''
  end

  local ok_exists, exists = pcall(grapple.exists, { buffer = 0 })
  if not ok_exists or not exists then
    return ''
  end

  local ok_tag, tag = pcall(grapple.name_or_index, { buffer = 0 })
  if not ok_tag or not tag or tag == '' then
    return ''
  end

  return string.format('%%#StatusLineMode# %s %%*', tostring(tag))
end

function M.python_env()
  local venv = os.getenv 'VIRTUAL_ENV_PROMPT'
  return venv
      and string.format('%%#StatusLineMedium# %s%%*', venv:gsub('%s+', ''))
    or ''
end

function M.file_percentage()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  local t = vim.api.nvim_buf_line_count(0)
  return string.format(
    '%%#StatusLineMedium#  %d%%%% %%*',
    math.ceil(l / t * 100)
  )
end

function M.total_lines()
  return string.format('%%#StatusLineMedium#of %d %%*', vim.fn.line '$')
end

function M.filetype(hl)
  return string.format('%%#%s# %s %%*', hl, vim.bo.filetype)
end

return M
