local running_kitty = os.getenv 'TERM' == 'xterm-kitty'

local kitty = require 'configs.kitty'

-- ============================================================================
-- Window Navigation
-- ============================================================================
vim.keymap.set('n', '<C-h>', running_kitty and function()
  kitty.nav 'h'
end or '<C-w>h', { desc = 'Move cursor to left window' })

vim.keymap.set('n', '<C-j>', running_kitty and function()
  kitty.nav 'j'
end or '<C-w>j', { desc = 'Move cursor to bottom window' })

vim.keymap.set('n', '<C-k>', running_kitty and function()
  kitty.nav 'k'
end or '<C-w>k', { desc = 'Move cursor to top window' })

vim.keymap.set('n', '<C-l>', running_kitty and function()
  kitty.nav 'l'
end or '<C-w>l', { desc = 'Move cursor to right window' })

-- ============================================================================
-- Window Resize
-- ============================================================================
vim.keymap.set('n', '<C-Up>', ':resize -2<cr>', {
  silent = true,
  desc = 'Decrease window height',
})

vim.keymap.set('n', '<C-Down>', ':resize +2<cr>', {
  silent = true,
  desc = 'Increase window height',
})

vim.keymap.set('n', '<C-Left>', ':vertical resize -2<cr>', {
  silent = true,
  desc = 'Decrease window width',
})

vim.keymap.set('n', '<C-Right>', ':vertical resize +2<cr>', {
  silent = true,
  desc = 'Increase window width',
})

-- ============================================================================
-- Buffers
-- ============================================================================
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', {
  silent = true,
  desc = 'Delete current buffer',
})

-- ============================================================================
-- Diagnostics
-- ============================================================================
vim.keymap.set('n', '<leader>dd', function()
  vim.diagnostic.setloclist()
end, { desc = 'Buffer diagnostics (loclist)' })

vim.keymap.set('n', '<leader>wd', function()
  vim.diagnostic.setqflist()
end, { desc = 'Workspace diagnostics (qflist)' })

-- ============================================================================
-- Search
-- ============================================================================
vim.keymap.set('n', '<leader>nh', ':nohlsearch<cr>', {
  silent = true,
  desc = 'Clear search highlight',
})


-- ============================================================================
-- Text Objects (simulate ci{ ci( etc. with _ - . <)
-- ============================================================================
vim.keymap.set('n', 'ci_', 'F_lvf_hc', {
  silent = true,
  noremap = true,
  desc = 'Change inner underscores',
})

vim.keymap.set('n', 'ci-', 'F-lvf-hc', {
  silent = true,
  noremap = true,
  desc = 'Change inner hyphens',
})

vim.keymap.set('n', 'ci.', 'F.lvf.hc', {
  silent = true,
  noremap = true,
  desc = 'Change inner dots',
})

vim.keymap.set('n', 'ci<', 'F>lvf<hc', {
  silent = true,
  noremap = true,
  desc = 'Change inner angle brackets',
})

-- ============================================================================
-- Clipboard
-- ============================================================================
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], {
  desc = 'Yank to system clipboard',
})

vim.keymap.set('n', '<leader>Y', [["+Y]], {
  desc = 'Yank line to system clipboard',
})

-- ============================================================================
-- Toggle/Switch
-- ============================================================================
vim.keymap.set('n', '<leader>sb', function()
  vim.opt.background = vim.o.background == 'dark' and 'light' or 'dark'
  if running_kitty and vim.g.neovide == nil then
    local cmd = 'kitten themes --cache-age=-1 ' .. 'cold_' .. vim.o.background
    vim.fn.system(cmd)
  end
end, { desc = 'Switch background (dark/light)' })

vim.keymap.set('n', '<leader>sw', function()
  vim.opt.wrap = not vim.o.wrap
end, { desc = 'Toggle line wrap' })

vim.keymap.set('n', '<leader>ch', function()
  vim.opt.cmdheight = vim.o.cmdheight == 0 and 1 or 0
end, { silent = true, desc = 'Toggle cmdheight (0/1)' })

-- ============================================================================
-- Terminal
-- ============================================================================
vim.keymap.set('n', '<leader>vt', [[<cmd>vsplit | term<cr>A]], {
  desc = 'Open terminal (vertical split)',
})

vim.keymap.set('n', '<leader>st', [[<cmd>split | term<cr>A]], {
  desc = 'Open terminal (horizontal split)',
})

vim.keymap.set('t', 'jk', '<C-\\><C-n>', {
  desc = 'Exit terminal mode',
})

-- ============================================================================
-- Insert Mode
-- ============================================================================
vim.keymap.set('i', 'jk', '<esc>', {
  desc = 'Exit insert mode',
})

-- ============================================================================
-- Quality of Life
-- ============================================================================
vim.keymap.set('n', 'x', '"_x', {
  desc = 'Delete char (no yank)',
})

vim.keymap.set('n', '<C-a>', 'gg<S-v>G', {
  desc = 'Select all',
})

vim.keymap.set('n', '<leader>fc', '<cmd>foldclose<cr>', {
  desc = 'Close fold',
})

vim.keymap.set('v', '<', '<gv', {
  desc = 'Indent left (stay in visual)',
})

vim.keymap.set('v', '>', '>gv', {
  desc = 'Indent right (stay in visual)',
})

vim.keymap.set('v', 'p', '"_dP', {
  noremap = true,
  silent = true,
  desc = 'Paste without yanking selection',
})

vim.keymap.set('x', '/', '<Esc>/\\%V', {
  desc = 'Search within visual selection',
})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
  desc = "Shift visual line down"
})

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {
  desc = "Shift visual line up"
})

vim.keymap.set('n', 'dd', function()
  if vim.fn.getline('.'):match '^%s*$' then
    return '"_dd'
  end
  return 'dd'
end, { expr = true, desc = 'Delete line (no yank if empty)' })


vim.keymap.set('n', '<leader>e', function()
  require('oil').toggle_float()
end, {
  desc = 'Toggle Oil file explorer',
})

vim.keymap.set('n', '-', function()
  require('oil').open()
end, {
  desc = 'Open parent directory',
})


vim.keymap.set('n', '<leader>rc', require('core.utils').reload_config, { desc = 'Reload nvim config' })
