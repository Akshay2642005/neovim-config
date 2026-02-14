vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup(
    'jump_to_the_last_known_cursor_position',
    { clear = true }
  ),
  pattern = { '*' },
  desc = 'When editing a file, always jump to the last known cursor position',
  callback = function()
    local line = vim.fn.line '\'"'
    if
        line >= 1
        and line <= vim.fn.line '$'
        and vim.bo.filetype ~= 'commit'
        and vim.fn.index({ 'xxd', 'gitrebase' }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeave', {
  group = vim.api.nvim_create_augroup(
    'cfg_restore_cursor_shape_on_exit',
    { clear = true }
  ),
  pattern = { '*' },
  desc = 'Restores vertical shape cursor for Alacritty on exit',
  callback = function()
    vim.opt.guicursor = 'a:ver1'
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup(
    'cfg_clean_term_mode',
    { clear = true }
  ),
  pattern = { '*' },
  desc = 'Disable line numbers, relative numbers, and signcolumn in terminal buffers',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup(
    'cfg_json_conceal_level_0',
    { clear = true }
  ),
  desc = 'Disable conceallevel and spell for JSON and JSONC',
  pattern = { 'json', 'jsonc' },
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('cfg_close_with_q', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'help',
    'man',
    'qf',
    'query',
    'scratch',
    'spectre_panel',
  },
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
  end,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = vim.api.nvim_create_augroup(
    'cfg_cmdheight_1_on_cmdlineenter',
    { clear = true }
  ),
  desc = 'Don\'t hide the status line when typing a command',
  command = ':set cmdheight=1',
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = vim.api.nvim_create_augroup(
    'cfg_cmdheight_0_on_cmdlineleave',
    { clear = true }
  ),
  desc = 'Hide cmdline when not typing a command',
  command = ':set cmdheight=0',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup(
    'cfg_highlight_on_yank',
    { clear = true }
  ),
  desc = 'Highlight on yank',
  callback = function()
    vim.highlight.on_yank { higroup = 'Search' }
  end,
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup(
--         'cfg_lsp_attach_conflicts',
--         { clear = true }
--     ),
--     desc = 'Prevent tsserver and volar conflict',
--     callback = function(args)
--         if not (args.data and args.data.client_id) then
--             return
--         end
--
--         local active_clients = vim.lsp.get_clients()
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--
--         if client ~= nil and client.name == 'volar' then
--             for _, c in ipairs(active_clients) do
--                 if c.name == 'tsserver' then
--                     c.stop()
--                 end
--             end
--         end
--     end,
-- })

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup(
    'cfg_avoid_comment_new_line',
    { clear = true }
  ),
  desc = 'Avoid comment on new line',
  command = 'set formatoptions-=cro',
})

vim.api.nvim_create_autocmd('VimResized', {
  group = vim.api.nvim_create_augroup(
    'cfg_consistent_size_buffers',
    { clear = true }
  ),
  desc = 'Keep consistent size for buffers',
  command = 'tabdo wincmd =',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup(
    'cfg_config_for_markdown',
    { clear = true }
  ),
  pattern = { 'markdown' },
  desc = 'Config for Git Markdown',
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup(
    'cfg_hide_message_after_write',
    { clear = true }
  ),
  desc = 'Get rid of message after writing a file',
  pattern = { '*' },
  command = 'redrawstatus',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('cfg_nowrap', { clear = true }),
  desc = 'No wrap in these filetypes',
  pattern = { 'checkhealth' },
  command = ':set nowrap',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup(
    'cfg_remove_char_from_iskeyword',
    { clear = true }
  ),
  desc = 'Remove - fro iskeyword option',
  pattern = { 'astro' },
  command = 'setlocal iskeyword-=-',
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "grapple",
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    local function cycle_next()
      local line = vim.fn.line(".")
      local last = vim.fn.line("$")

      if line >= last then
        vim.cmd("normal! gg")
      else
        vim.cmd("normal! j")
      end
    end
    local function cycle_prev()
      local line = vim.fn.line(".")

      if line <= 1 then
        vim.cmd("normal! G")
      else
        vim.cmd("normal! k")
      end
    end
    vim.keymap.set("n", "<Tab>", cycle_next, opts)
    vim.keymap.set("n", "<S-Tab>", cycle_prev, opts)
  end,
})

local shada_group = vim.api.nvim_create_augroup("ShadaManager", { clear = true })

local function cleanup_shada()
  local shada_path = vim.fn.expand("$LOCALAPPDATA/nvim-data/shada/")
  local tmp_files = vim.fn.glob(shada_path .. "*.tmp*", true, true)
  if #tmp_files > 0 then
    for _, file in ipairs(tmp_files) do
      pcall(os.remove, file)
    end
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = shada_group,
  callback = cleanup_shada,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = shada_group,
  callback = cleanup_shada,
})


local function change_wezterm_bg(color)
  -- We use the 'sed' or 'printf' style through a system call to ensure
  -- the escape sequence is sent directly to the active terminal stdout.
  local osc_seq = string.format("\27]11;%s\27\\", color)
  vim.fn.chansend(vim.v.stderr, osc_seq)
end

local wez_group = vim.api.nvim_create_augroup("WeztermColors", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = wez_group,
  callback = function()
    change_wezterm_bg("#0e0e0e")
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  group = wez_group,
  callback = function()
    change_wezterm_bg("#000000")
  end,
})
