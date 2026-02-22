local M = {}

local augroup = vim.api.nvim_create_augroup("statusline_hl", { clear = true })

function M.setup()
  local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
  local bg = statusline_hl.bg

  vim.api.nvim_set_hl(0, 'StatusLineCopilot', { fg = '#6CC644', bg = bg })
  vim.api.nvim_set_hl(0, 'StatusLineCopilotInactive', { fg = '#555555', bg = bg })

  vim.api.nvim_set_hl(0, "StatusLineBuildRunning", { fg = "#e5c07b", bg = bg })
  vim.api.nvim_set_hl(0, "StatusLineBuildSuccess", { fg = "#98c379", bg = bg })
  vim.api.nvim_set_hl(0, "StatusLineBuildFailure", { fg = "#e06c75", bg = bg })

  local function ensure(name, opts)
    if vim.fn.hlexists(name) == 0 or vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = name })) then
      vim.api.nvim_set_hl(0, name, opts)
    end
  end

  ensure('StatusLineMedium', { fg = '#abb2bf', bg = bg })
  ensure('StatusLineGitDiffAdded', { fg = '#98c379', bg = bg })
  ensure('StatusLineGitDiffChanged', { fg = '#e5c07b', bg = bg })
  ensure('StatusLineGitDiffRemoved', { fg = '#e06c75', bg = bg })
  ensure('StatusLineMode', { fg = '#000000', bg = '#61afef', bold = true })
  ensure('StatusLineLspError', { fg = '#e06c75', bg = bg })
  ensure('StatusLineLspWarn', { fg = '#e5c07b', bg = bg })
  ensure('StatusLineLspHint', { fg = '#98c379', bg = bg })
  ensure('StatusLineLspInfo', { fg = '#61afef', bg = bg })
  ensure('StatusLineLspMessages', { fg = '#888888', bg = bg })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = M.setup,
})

return M
