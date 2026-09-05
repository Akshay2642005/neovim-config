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
-- Buffers / Tabs
-- ============================================================================
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', {
  silent = true,
  desc = 'Delete current buffer',
})

vim.keymap.set('n', '<leader>bD', function()
  require('bufferline').close_others()
end, { silent = true, desc = 'Close other buffers' })

vim.keymap.set('n', '<leader>bp', function()
  require('bufferline').pick()
end, { silent = true, desc = 'Pick buffer' })

vim.keymap.set('n', '<Tab>', function()
  require('bufferline').cycle(1)
end, { silent = true, desc = 'Next buffer' })

vim.keymap.set('n', '<S-Tab>', function()
  require('bufferline').cycle(-1)
end, { silent = true, desc = 'Previous buffer' })

vim.keymap.set('n', ']b', function()
  require('bufferline').cycle(1)
end, { silent = true, desc = 'Next buffer' })

vim.keymap.set('n', '[b', function()
  require('bufferline').cycle(-1)
end, { silent = true, desc = 'Previous buffer' })

vim.keymap.set('n', '<leader>bh', function()
  require('bufferline').move(-1)
end, { silent = true, desc = 'Move buffer left' })

vim.keymap.set('n', '<leader>bl', function()
  require('bufferline').move(1)
end, { silent = true, desc = 'Move buffer right' })

-- ============================================================================
-- Diagnostics
-- ============================================================================
-- NOTE: <leader>dd / <leader>wd are owned by plugins.trouble (lazy keys).
-- Defining them here too would shadow Trouble's toggle, so they live
-- only in lua/plugins/trouble.lua. Raw :copen / :lopen windows still use
-- the beautified `file:lnum:col [type]: message` format from core.ui.qflist.

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

vim.keymap.set('n', '<leader>sh', [[<cmd>split | term<cr>A]], {
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
-- Quickfix / Location List
-- ============================================================================
vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous quickfix' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix' })
vim.keymap.set('n', '[l', '<cmd>lprev<cr>', { desc = 'Previous loclist' })
vim.keymap.set('n', ']l', '<cmd>lnext<cr>', { desc = 'Next loclist' })

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

vim.keymap.set('n', '<leader>fC', '<cmd>foldopen<cr>', {
  desc = 'Open fold',
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

vim.keymap.set('n', '<D-r>', "<CMD>OverseerRun<CR>", { desc = 'Run Build Task' })
vim.keymap.set('n', '<D-o>', "<CMD>OverseerOpen<CR>", { desc = 'Toggle Task List' })



vim.keymap.set('n', '<leader>dt', require('core.utils').setup_docker_mode, { desc = 'Toggle Docker Terminal' })

vim.keymap.set('n', '<leader>rc', require('core.utils').reload_config, { desc = 'Reload nvim config' })
