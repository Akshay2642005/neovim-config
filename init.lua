-- Optimize startup: load options first (includes vim.loader.enable())
require 'core.options'
require 'core.utils'
-- Load lazy.nvim and plugins (this should be early)
require 'setup'

-- Load keymaps after plugins so plugin keymaps work
require 'core.keymaps'

-- Load these after plugins are available
require 'core.autocmds'
require 'core.commands'

-- UI components (statusline needs to load after colorscheme)
require 'core.statusline'
require 'core.winbar'
require 'core.terminalcolors'
