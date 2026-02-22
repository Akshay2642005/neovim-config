local M = {}

function M.lsp_active()
  if not rawget(vim, 'lsp') then return '' end
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local names = {}
  for _, client in ipairs(clients) do
    if client.name ~= 'copilot' then
      table.insert(names, client.name)
    end
  end

  if #names == 0 then return '' end

  return string.format('%%#StatusLineMedium# LSP [%s] %%*', table.concat(names, ', '))
end

function M.python_env()
  local venv = os.getenv('VIRTUAL_ENV_PROMPT')
  return venv and string.format('%%#StatusLineMedium# %s%%*', venv:gsub('%s+', '')) or ''
end

function M.file_percentage()
  local l = vim.api.nvim_win_get_cursor(0)[1]
  local t = vim.api.nvim_buf_line_count(0)
  return string.format('%%#StatusLineMedium#  %d%%%% %%*', math.ceil(l / t * 100))
end

function M.total_lines()
  return string.format('%%#StatusLineMedium#of %d %%*', vim.fn.line('$'))
end

function M.filetype(hl)
  return string.format('%%#%s# %s %%*', hl, vim.bo.filetype)
end

return M
