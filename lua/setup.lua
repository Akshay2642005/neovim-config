--- This module sets up and configures lazy loading for Neovim plugins using the 'lazy.nvim' manager.
--- It initializes the plugin specifications, ensures the 'lazy.nvim' manager is installed,
--- and configures various options for plugin loading, updates, and performance improvements.

--- Container for plugin specifications.
--- Each entry contains an import path for a plugin module.
local plugin_specs = {} --- @type LazySpecImport[]

--- Adds a plugin specification to the table of plugin specifications.
--- @param plugin string The module path of the plugin to add as a lazy-loaded plugin.
local function add(plugin)
  --- Define a plugin specification with the given module path.
  local spec = { import = plugin } --- @type LazySpecImport

  --- Add the specification to the list of plugin specifications.
  table.insert(plugin_specs, spec)
end

-- Plugin imports; these can be customized as needed for the user's configuration.
add 'plugins.autopairs'
add 'plugins.autotag'
add 'plugins.blink-cmp'
add 'plugins.colorizer'
add 'plugins.colorschemes.cold' -- Load 'cold' colorscheme explicitly
-- add 'plugins.colorschemes.black_white'
add 'plugins.flash'
add 'plugins.formatter'
add 'plugins.grapple'
add 'plugins.gitsigns'
-- add 'plugins.jdtls'  -- Example of a disabled plugin
add 'plugins.lsp'
add 'plugins.mason'
add 'plugins.mini-surround'
add 'plugins.oil'
add 'plugins.persistence'
add 'plugins.snacks'
add 'plugins.todo-comments'
add 'plugins.treesitter'
add 'plugins.treesitter-context'
add 'plugins.ts-comments'
add 'plugins.undotree'
add 'plugins.web-devicons'
add 'plugins.zen-mode'
add 'plugins.which-key'
add 'plugins.avante'
add 'plugins.alpha'

--- Compute the installation path for 'lazy.nvim'.
--- This is used to ensure the plugin manager itself is installed locally.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

--- Check if 'lazy.nvim' is installed, and install it if necessary.
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end

--- Prepend 'lazy.nvim' installation path to Neovim's runtime path.
vim.opt.rtp:prepend(lazypath)

--- Configure and initialize 'lazy.nvim' with the specified plugin specifications.
require('lazy').setup(plugin_specs, {
  defaults = {
    lazy = true, -- Lazy load all plugins by default for speed.
  },
  ui = {
    border = 'single', -- Use a single-line border for plugin manager UI.
    backdrop = 100,    -- Set backdrop transparency for UI.
  },
  checker = {
    enabled = false, -- Disable automatic update checking by default.
    notify = false,  -- Suppress update notifications.
  },
  change_detection = {
    enabled = false, -- Disable auto-reloading on configuration changes.
    notify = false,  -- Suppress change detection notifications.
  },
  install = {
    colorscheme = { 'cold' }, -- Attempt to load the 'cold' colorscheme during installation.
  },
  performance = {
    cache = {
      enabled = true,      -- Enable caching to improve startup times.
    },
    reset_packpath = true, -- Reset default package paths to optimize startup performance.
    rtp = {
      reset = true,        -- Reset runtime paths for improved startup consistency.
      disabled_plugins = { -- List of default plugins disabled for better performance.
        '2html_plugin',
        'bugreport',
        'compiler',
        'ftplugin',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'matchit',
        'netrw',
        'netrwFileHandlers',
        'netrwPlugin',
        'netrwSettings',
        'optwin',
        'rplugin',
        'rrhelper',
        'spellfile_plugin',
        'synmenu',
        'syntax',
        'tar',
        'tarPlugin',
        'tohtml',
        'tutor',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
})
