local M = {}

function M.setup()
  local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
  local bg = statusline_hl.bg

  vim.api.nvim_set_hl(0, "StatusLineBuildRunning", { fg = "#e5c07b", bg = bg })
  vim.api.nvim_set_hl(0, "StatusLineBuildSuccess", { fg = "#98c379", bg = bg })
  vim.api.nvim_set_hl(0, "StatusLineBuildFailure", { fg = "#e06c75", bg = bg })

  local function ensure(name, opts)
    if vim.fn.hlexists(name) == 0 or vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = name })) then
      vim.api.nvim_set_hl(0, name, opts)
    end
  end

  ensure('StatusLineMedium', { fg = '#abb2bf', bg = bg })
  ensure('StatusLineMode', { fg = '#000000', bg = '#61afef', bold = true })
  ensure('StatusLineLspError', { fg = '#e06c75', bg = bg })
  ensure('StatusLineLspWarn', { fg = '#e5c07b', bg = bg })
  ensure('StatusLineLspHint', { fg = '#98c379', bg = bg })
  ensure('StatusLineLspInfo', { fg = '#61afef', bg = bg })
  ensure('StatusLineLspMessages', { fg = '#888888', bg = bg })
end

return M
