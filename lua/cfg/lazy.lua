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
add 'cfg.plugins.formatter'
add 'cfg.plugins.grapple'
add 'cfg.plugins.gitsigns'
add 'cfg.plugins.jdtls'
add 'cfg.plugins.lsp'
add 'cfg.plugins.mason'
add 'cfg.plugins.mini-surround'
add 'cfg.plugins.oil'
add 'cfg.plugins.snacks'
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
  ui = {
    border = 'single',
    backdrop = 100,
  },
  change_detection = {
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
