-- Performance optimizations (must be at the very top)
vim.loader.enable() -- Enable byte-compiled lua cache

-- Disable providers we don't use
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Disable built-in plugins we don't need
vim.g.editorconfig = false
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
-- vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_typecorr = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_rplugin = 1

-- for some reason vim (not neovim) loads a sql plugin for completion,
-- this plugins maps <C-c>, this disabled that mapping
vim.g.omni_sql_no_default_maps = 1

-- Disable snacks animations for performance
vim.g.snacks_animate = false

local opt = vim.opt

-- Performance options
opt.lazyredraw = false -- Don't use with noice.nvim
opt.ttyfast = true     -- Faster terminal connection
opt.synmaxcol = 240    -- Only highlight first 240 columns
opt.redrawtime = 1500  -- Time for redrawing the display (ms)

-- Reduce updatetime for faster CursorHold
opt.updatetime = 200
opt.timeoutlen = 400 -- Faster key sequence completion

-- Reduce memory usage
opt.history = 100     -- Reduce command history (default 10000)
opt.undolevels = 1000 -- Reduce undo levels (was 10000)

-- Disable backup and swap for speed
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Enable undo persistence
opt.undofile = true

-- UI options
opt.cmdheight = 1
opt.completeitemalign = 'abbr,menu,kind'
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.conceallevel = 3
opt.confirm = true
opt.cursorline = true
opt.expandtab = true

vim.opt.fillchars = {
  eob = " ",
  horiz = ' ',
  vert = ' ',
  horizup = ' ',
  horizdown = ' ',
  verthoriz = ' '
}
opt.foldcolumn = '0'
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = 'expr'
opt.foldtext = ''
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true
opt.laststatus = 3
opt.list = true
opt.mouse = 'a'
opt.number = true
opt.numberwidth = 1
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 2
opt.shell = 'powershell'
opt.shiftwidth = 2
opt.softtabstop = 2
opt.showcmd = true
opt.showcmdloc = 'statusline'
opt.showmode = false
opt.showtabline = 1
opt.sidescroll = 3
opt.sidescrolloff = 3
opt.signcolumn = 'yes'
opt.smartcase = false
opt.smartindent = true
opt.spell = false
opt.spelllang = 'en_us'
opt.spelloptions = 'camel'
opt.splitbelow = true
opt.splitkeep = 'screen'
opt.splitright = true
opt.tabstop = 2
opt.virtualedit = 'block'
opt.winborder = 'single'
opt.wrap = false

vim.g.base46_cache = vim.fn.stdpath 'data' .. '/base46_cache/'

if vim.g.neovide then
  opt.linespace = -1

  -- emulate alacritty font rendering
  vim.g.neovide_text_gamma = 0.8
  vim.g.neovide_text_contrast = 0.1

  -- padding
  vim.g.neovide_padding_top = 5
  vim.g.neovide_padding_left = 4

  -- disable blur
  vim.g.neovide_window_blurred = false
  vim.g.neovide_floating_shadow = false

  -- other options
  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.1

  vim.cmd [[
        " system clipboard
        nmap <c-c> "+y
        vmap <c-c> "+y
        nmap <c-v> "+p
        inoremap <c-v> <c-r>+
        cnoremap <c-v> <c-r>+
        " use <c-r> to insert original character without triggering things like auto-pairs
        inoremap <c-r> <c-v>
    ]]
end
