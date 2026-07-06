vim.keymap.set('n', '<leader>.', function()
  require('grapple').tag()
end, { desc = 'Grapple (toggle) current file' })

vim.keymap.set('n', ';', function()
  require('grapple').toggle_tags()
end, { desc = 'Grapple tag menu' })
