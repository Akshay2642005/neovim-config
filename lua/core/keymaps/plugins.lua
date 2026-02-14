-- ============================================================================
-- Flash
-- ============================================================================
vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash' })

vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })

vim.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })

vim.keymap.set({ 'o', 'x' }, 'R', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })

vim.keymap.set('c', '<C-s>', function()
  require('flash').toggle()
end, { desc = 'Toggle Flash Search' })

-- ============================================================================
-- Persistence (Session Management)
-- ============================================================================
vim.keymap.set('n', '<leader>qs', function()
  require('persistence').load()
end, { desc = 'Restore session' })

vim.keymap.set('n', '<leader>ql', function()
  require('persistence').load { last = true }
end, { desc = 'Restore last session' })

vim.keymap.set('n', '<leader>qd', function()
  require('persistence').stop()
end, { desc = "Don't save current session" })

vim.keymap.set('n', '<leader>qS', function()
  require('persistence').select()
end, { desc = 'Select session' })

-- ============================================================================
-- TODO Comments
-- ============================================================================
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next TODO' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous TODO' })

vim.keymap.set('n', '<leader>st', function()
  Snacks.picker.todo_comments()
end, { desc = 'Search TODOs' })

vim.keymap.set('n', '<leader>sT', function()
  Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
end, { desc = 'Search TODO/FIX/FIXME' })

vim.keymap.set('n', '<leader>tq', '<cmd>TodoQuickFix<cr>', {
  silent = true,
  desc = 'TODOs to quickfix',
})

vim.keymap.set('n', '<leader>tl', '<cmd>TodoLocList<cr>', {
  silent = true,
  desc = 'TODOs to loclist',
})

-- ============================================================================
-- Which-key
-- ============================================================================
vim.keymap.set('n', '<leader>?', function()
  require('which-key').show { global = false }
end, { desc = 'Buffer local keymaps' })
