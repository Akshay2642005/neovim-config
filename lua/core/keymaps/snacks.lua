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

vim.keymap.set('n', '<leader>lg', ':SnacksPickerGrep<cr>', {
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

-- ============================================================================
-- Snacks Lazygit
-- ============================================================================
vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit.open {
    win = {
      position = 'float',
      border = 'single',
      width = 0.9,
      height = 0.9,
    },
  }
end, {
  silent = true,
  desc = 'Lazygit',
})

vim.keymap.set('n', '<leader>gl', function()
  Snacks.lazygit.log {
    win = {
      position = 'float',
      border = 'single',
      width = 0.9,
      height = 0.9,
    },
  }
end, {
  silent = true,
  desc = 'Lazygit log (cwd)',
})

vim.keymap.set('n', '<leader>gf', function()
  Snacks.lazygit.log_file {
    win = {
      position = 'float',
      border = 'single',
      width = 0.9,
      height = 0.9,
    },
  }
end, {
  silent = true,
  desc = 'Lazygit log (current file)',
})

vim.keymap.set('n', '<leader>gb', function()
  Snacks.git.blame_line()
end, {
  silent = true,
  desc = 'Git blame line',
})

-- ============================================================================
-- Snacks Terminal
-- ============================================================================
vim.keymap.set({ 'n', 't' }, '<C-/>', function()
  Snacks.terminal.toggle()
end, {
  silent = true,
  desc = 'Toggle terminal',
})

vim.keymap.set({ 'n', 't' }, '<C-_>', function()
  Snacks.terminal.toggle()
end, {
  silent = true,
  desc = 'Toggle terminal',
})
