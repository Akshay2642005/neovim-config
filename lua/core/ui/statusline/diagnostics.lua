local M = {}

-- [bufnr] -> { [severity]: count }
local counts = {}

local augroup = vim.api.nvim_create_augroup('statusline_diagnostics', { clear = true })

local function recount(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  -- Read counts from the buffer itself, not the event payload: the
  -- DiagnosticChanged payload shape varies across Neovim versions, and a
  -- stale empty cache pinned counts at zero even with visible diagnostics.
  counts[bufnr] = vim.diagnostic.count(bufnr)
  vim.cmd.redrawstatus()
end

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = augroup,
  desc = 'Cache diagnostic counts for the statusline',
  callback = function(args)
    recount(args.buf)
  end,
})

vim.api.nvim_create_autocmd({ 'BufWipeout', 'BufDelete' }, {
  group = augroup,
  desc = 'Drop cached diagnostic counts for deleted buffers',
  callback = function(args)
    counts[args.buf] = nil
  end,
})

local function n(sev)
  local bufnr = vim.api.nvim_get_current_buf()
  local c = counts[bufnr]
  if c == nil then
    -- seed once for buffers whose diagnostics arrived before this module loaded
    c = vim.diagnostic.count(bufnr)
    counts[bufnr] = c
  end
  return c[sev] or 0
end

function M.error()
  local count = n(vim.diagnostic.severity.ERROR)
  return count > 0 and string.format('%%#StatusLineLspError# %se%%*', count) or ''
end

function M.warn()
  local count = n(vim.diagnostic.severity.WARN)
  return count > 0 and string.format('%%#StatusLineLspWarn# %sw%%*', count) or ''
end

function M.hint()
  local count = n(vim.diagnostic.severity.HINT)
  return count > 0 and string.format('%%#StatusLineLspHint# %sh%%*', count) or ''
end

function M.info()
  local count = n(vim.diagnostic.severity.INFO)
  return count > 0 and string.format('%%#StatusLineLspInfo# %si%%*', count) or ''
end

return M
