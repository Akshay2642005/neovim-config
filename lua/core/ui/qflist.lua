-- Beautified quickfix / location-list lines: `file:lnum:col [type]: text`
-- e.g. `lua/core/ui/qflist.lua:12:5 [error]: undefined global 'foo'`
-- No tree UI (per preference); this only affects how each qf line reads.
local M = {}

local TYPE_LABEL = {
  E = 'error',
  W = 'warn',
  I = 'info',
  N = 'hint',
}

--- @param info table quickfixtextfunc info ({quickfix, winid, start_idx, end_idx})
--- @return string[] formatted lines
function M.qftf(info)
  local list = info.quickfix == 1 and vim.fn.getqflist(info) or vim.fn.getloclist(info.winid)
  local lines = {}
  for i = info.start_idx, info.end_idx do
    local item = list[i]
    if not item then
      lines[#lines + 1] = ''
    else
      local fname = item.bufnr > 0 and vim.fn.bufname(item.bufnr) or ''
      if fname == '' then
        fname = '[no file]'
      else
        fname = vim.fn.fnamemodify(fname, ':.')
      end
      local label = TYPE_LABEL[item.type] or (item.type ~= '' and item.type:lower() or 'info')
      local text = (item.text or ''):gsub('\n', ' ')
      lines[#lines + 1] = string.format('%s:%d:%d [%s]: %s', fname, item.lnum, item.col, label, text)
    end
  end
  return lines
end

local group = vim.api.nvim_create_augroup('beautified_qf', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'qf',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.cursorline = true
    vim.keymap.set('n', 'q', '<cmd>cclose|lclose<cr>', { buffer = true, silent = true, desc = 'Close quickfix' })
  end,
})

vim.o.quickfixtextfunc = "v:lua.require'core.ui.qflist'.qftf"

return M
