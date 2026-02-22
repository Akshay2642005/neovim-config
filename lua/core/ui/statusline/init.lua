local build = require('core.ui.statusline.build_status')
local highlights = require('core.ui.statusline.highlights')
local mode = require('core.ui.statusline.mode')
local diag = require('core.ui.statusline.diagnostics')
local lsp_progress = require('core.ui.statusline.lsp_progress')
local c = require('core.ui.statusline.components')

local augroup = vim.api.nvim_create_augroup('statusline', { clear = true })

highlights.setup()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  callback = highlights.setup,
})

StatusLine = {}

StatusLine.active = function()
  local m = vim.api.nvim_get_mode().mode
  if m == 't' or vim.o.modifiable == false then
    return table.concat {
      mode.component(),
      '%=',
      c.file_percentage(),
      c.total_lines(),
    }
  end

  return table.concat {
    mode.component(),
    build.component(),
    '%=',
    '%S ',
    lsp_progress.component(),
    diag.error(),
    diag.warn(),
    diag.hint(),
    diag.info(),
    c.lsp_active(),
    c.python_env(),
    c.file_percentage(),
  }
end

vim.opt.laststatus = 3
vim.opt.statusline = '%!v:lua.StatusLine.active()'
