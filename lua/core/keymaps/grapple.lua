vim.keymap.set('n', ';', "<cmd>lua require('grapple').toggle_tags()<cr>", {
  desc = 'Grapple menu',
})
