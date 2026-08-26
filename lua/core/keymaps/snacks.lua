-- ============================================================================
-- Snacks Picker
-- ============================================================================
vim.keymap.set('n', '<leader><space>', ':SnacksPickerFiles<cr>', {
  silent = true,
  desc = 'Find files',
})

vim.keymap.set('n', '<leader>ff', ':SnacksPickerFiles<cr>', {
  silent = true,
  desc = 'Find files',
})

vim.keymap.set('n', '<leader>gs', ':SnacksPickerGitStatus<cr>', {
  silent = true,
  desc = 'Git status',
})

vim.keymap.set('n', '<leader>gd', ':SnacksPickerGitDiff<cr>', {
  silent = true,
  desc = 'Git status',
})

vim.keymap.set('n', '<leader>cg', ':SnacksPickerGrep<cr>', {
  silent = true,
  desc = 'Live grep',
})

vim.keymap.set('n', '<leader>hh', ':SnacksPickerHelp<cr>', {
  silent = true,
  desc = 'Help tags',
})

vim.keymap.set('n', '<leader>bf', ':SnacksPickerBuffers<cr>', {
  silent = true,
  desc = 'Find buffers',
})

vim.keymap.set('n', '<leader>fp', ':SnacksPickerProjects<cr>', {
  silent = true,
  desc = 'Switch project',
})

vim.keymap.set('n', '<leader>fd', ':SnacksPickerDiagnostics<cr>', {
  silent = true,
  desc = 'Diagnostics',
})


-- ============================================================================
-- Snacks Terminal
-- ============================================================================
-- vim.keymap.set({ 'n', 't' }, '<C-/>', function()
--   Snacks.terminal.toggle()
-- end, {
--   silent = true,
--   desc = 'Toggle terminal',
-- })

-- vim.keymap.set({ 'n', 't' }, '<C-_>', function()
--   Snacks.terminal.toggle()
-- end, {
--   silent = true,
--   desc = 'Toggle terminal',
-- })
