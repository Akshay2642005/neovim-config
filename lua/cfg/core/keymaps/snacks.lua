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
