return {
  'gmr458/vscode_modern_theme.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local vscode_modern = require 'vscode_modern'

    vscode_modern.setup {
      cursorline = true,
    }

    vim.cmd.colorscheme 'vscode_modern'
  end,
}
