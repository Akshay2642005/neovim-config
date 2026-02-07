vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
local lhs_print = 'yoprintln!("'
    .. esc
    .. 'pA: {:#?}", '
    .. esc
    .. 'pA);'
    .. esc

vim.keymap.set('v', '<leader>l', lhs_print, {
  desc = 'println!() for text selected in visual mode',
  buffer = true,
  noremap = true,
})
