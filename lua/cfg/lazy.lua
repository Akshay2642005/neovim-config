local plugin_specs = {} --- @type LazySpecImport[]

--- @param plugin string
local function add(plugin)
  local spec = { import = plugin } --- @type LazySpecImport
  table.insert(plugin_specs, spec)
end

add 'cfg.plugins.autopairs'
add 'cfg.plugins.autotag'
add 'cfg.plugins.blink-cmp'
add 'cfg.plugins.colorizer'
add 'cfg.plugins.colorschemes.cold'
add 'cfg.plugins.flash'
add 'cfg.plugins.formatter'
add 'cfg.plugins.grapple'
add 'cfg.plugins.gitsigns'
add 'cfg.plugins.jdtls'
add 'cfg.plugins.lsp'
add 'cfg.plugins.mason'
add 'cfg.plugins.mini-surround'
add 'cfg.plugins.oil'
add 'cfg.plugins.persistence'
add 'cfg.plugins.snacks'
add 'cfg.plugins.todo-comments'
add 'cfg.plugins.treesitter'
add 'cfg.plugins.treesitter-context'
add 'cfg.plugins.ts-comments'
add 'cfg.plugins.undotree'
add 'cfg.plugins.web-devicons'
add 'cfg.plugins.zen-mode'
add 'cfg.plugins.which-key'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

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

vim.opt.rtp:prepend(lazypath)

require('lazy').setup(plugin_specs, {
  defaults = {
    lazy = true, -- Lazy load all plugins by default
  },
  ui = {
    border = 'single',
    backdrop = 100,
  },
  checker = {
    enabled = false, -- Don't check for updates automatically
    notify = false,
  },
  change_detection = {
    enabled = false, -- Don't auto-reload on config change
    notify = false,
  },
  install = {
    colorscheme = { 'cold' }, -- Try to load colorscheme on install
  },
  performance = {
    cache = {
      enabled = true,      -- Enable caching
    },
    reset_packpath = true, -- Reset packpath to improve startup
    rtp = {
      reset = true,        -- Reset runtimepath for better startup
      disabled_plugins = {
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
