local M = {}

local function count(sev)
  if not rawget(vim, 'lsp') then return 0 end
  return vim.diagnostic.count(0, { severity = sev })[sev] or 0
end

function M.error()
  local n = count(vim.diagnostic.severity.ERROR)
  return n > 0 and string.format('%%#StatusLineLspError# %se%%*', n) or ''
end

function M.warn()
  local n = count(vim.diagnostic.severity.WARN)
  return n > 0 and string.format('%%#StatusLineLspWarn# %sw%%*', n) or ''
end

function M.hint()
  local n = count(vim.diagnostic.severity.HINT)
  return n > 0 and string.format('%%#StatusLineLspHint# %sh%%*', n) or ''
end

function M.info()
  local n = count(vim.diagnostic.severity.INFO)
  return n > 0 and string.format('%%#StatusLineLspInfo# %si%%*', n) or ''
end

return M
