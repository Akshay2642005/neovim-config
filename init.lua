-- Optimize startup: load options first (includes vim.loader.enable())
require 'core.options'
require 'core.utils'

-- Set mapleader BEFORE lazy.nvim loads (plugins depend on it)
vim.g.mapleader = ' '

-- Load lazy.nvim and plugins (this should be early)
require 'setup'

-- Load keymaps after plugins so plugin keymaps work
require 'core.keymaps'

-- Load these after plugins are available
require 'core.autocmds'
require 'core.commands'

-- UI components (statusline needs to load after colorscheme)
require 'core.ui.statusline'
require 'core.terminalcolors'
