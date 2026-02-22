local M = {}

local mode_names = {
  n = 'NORMAL',
  no = 'O-PENDING',
  nov = 'O-PENDING',
  noV = 'O-PENDING',
  ['no\22'] = 'O-PENDING',
  niI = 'NORMAL',
  niR = 'NORMAL',
  niV = 'NORMAL',
  nt = 'NORMAL',
  ntT = 'NORMAL',
  v = 'VISUAL',
  vs = 'VISUAL',
  V = 'V-LINE',
  Vs = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  ['\22s'] = 'V-BLOCK',
  s = 'SELECT',
  S = 'S-LINE',
  ['\19'] = 'S-BLOCK',
  i = 'INSERT',
  ic = 'INSERT',
  ix = 'INSERT',
  R = 'REPLACE',
  Rc = 'REPLACE',
  Rx = 'REPLACE',
  Rv = 'V-REPLACE',
  Rvc = 'V-REPLACE',
  Rvx = 'V-REPLACE',
  c = 'COMMAND',
  cv = 'EX',
  ce = 'EX',
  r = 'REPLACE',
  rm = 'MORE',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  t = 'TERMINAL',
}

function M.component()
  local m = vim.api.nvim_get_mode().mode
  return string.format('%%#StatusLineMode# %s %%*', mode_names[m] or m)
end

return M
