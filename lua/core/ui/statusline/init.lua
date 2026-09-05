local build = require 'core.ui.statusline.build_status'
local highlights = require 'core.ui.statusline.highlights'
local mode = require 'core.ui.statusline.mode'
local diag = require 'core.ui.statusline.diagnostics'
local lsp_progress = require 'core.ui.statusline.lsp_progress'
local c = require 'core.ui.statusline.components'

local augroup = vim.api.nvim_create_augroup('statusline', { clear = true })

highlights.setup()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  callback = highlights.setup,
})

-- keep the recording indicator responsive (mode changes alone don't redraw it)
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  group = augroup,
  callback = function()
    vim.cmd.redrawstatus()
  end,
})

_G.StatusLine = {}

_G.StatusLine.active = function()
  local m = vim.api.nvim_get_mode().mode
  if m == 't' or vim.o.modifiable == false then
    return table.concat {
      mode.component(),
      c.macro(),
      '%=',
      c.file_percentage(),
      c.total_lines(),
    }
  end

  -- Diagnostics sit left after the git branch so the LSP progress
  -- spinner (center-right) can never overlap or visually crowd them.
  -- double '%=' centers the build segment; '%<' makes the right side
  -- collapse first on narrow windows while mode/git/diag stay visible
  return table.concat {
    mode.component(),
    c.macro(),
    c.git_branch(),
    diag.error(),
    diag.warn(),
    diag.hint(),
    diag.info(),
    '%=',
    '%<',
    '%S ',
    lsp_progress.component(),
    build.icon(),
    c.lsp_active(),
    c.python_env(),
    c.file_percentage(),
  }
end

vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'qf',
  callback = function()
    vim.wo.statusline = '%!v:lua.StatusLine.active()'
  end,
})

vim.opt.statusline = '%!v:lua.StatusLine.active()'
vim.opt.laststatus = 3
