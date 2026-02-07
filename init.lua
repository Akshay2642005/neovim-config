-- Optimize startup: load options first (includes vim.loader.enable())
require 'cfg.core.options'

-- Load lazy.nvim and plugins (this should be early)
require 'cfg.lazy'

-- Load keymaps after plugins so plugin keymaps work
require 'cfg.core.keymaps'

-- Load these after plugins are available
require 'cfg.core.autocmds'
require 'cfg.core.commands'

-- UI components (can be deferred slightly)
vim.schedule(function()
  require 'cfg.core.statusline'
  require 'cfg.core.winbar'
  require 'cfg.core.terminalcolors'
end)
