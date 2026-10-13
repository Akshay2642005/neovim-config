return {
  'stevearc/oil.nvim',
  lazy = true,
  priority = 1000,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  init = function()
    -- oil's default_file_explorer (kept enabled) owns directory buffers, and its
    -- WinNew handler looks for a parent window via `vim.w.oil_did_enter` to copy
    -- window state when splitting. During startup / session restore a new window can
    -- be created on an oil buffer before *any* window has been "entered", which makes
    -- oil spam the spurious "Oil split could not find parent window" warning. Register
    -- this handler before oil's own (this augroup is created in `init`, before oil's
    -- setup runs) and only act when that race really happened: no window has
    -- oil_did_enter set. When a real parent exists we do nothing, so oil's original
    -- handler still copies the window variables.
    local augroup =
      vim.api.nvim_create_augroup('oil_winnew_fix', { clear = true })
    vim.api.nvim_create_autocmd('WinNew', {
      group = augroup,
      pattern = '*',
      desc = 'Pre-seed oil window state to avoid spurious parent-window warning',
      callback = function(params)
        local name = vim.api.nvim_buf_get_name(params.buf)
        local is_oil = vim.bo[params.buf].filetype == 'oil'
          or vim.startswith(name, 'oil://')
          or vim.startswith(name, 'oil-ssh://')
        if not is_oil then
          return
        end
        -- If any window has already entered oil, a real parent exists: let oil's
        -- original WinNew handler find it and copy the window variables.
        local winids = vim.list_extend(
          vim.api.nvim_tabpage_list_wins(0),
          vim.api.nvim_list_wins()
        )
        for _, wid in ipairs(winids) do
          if vim.api.nvim_win_is_valid(wid) and vim.w[wid].oil_did_enter then
            return
          end
        end
        -- Startup race: no parent to find. Mark this window as an entered oil
        -- window so oil's handler early-returns instead of warning.
        vim.w.oil_did_enter = true
      end,
    })
  end,
  opts = {
    default_file_explorer = true,
    columns = {
      'icon',
    },
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },
    win_options = {
      wrap = false,
      signcolumn = 'no',
      cursorcolumn = false,
      foldcolumn = '0',
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = 'nvic',
    },
    delete_to_trash = false,
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = false,
    },
    constrain_cursor = 'editable',
    watch_for_changes = false,
    keymaps = {
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = { 'actions.close', mode = 'n' },
      ['q'] = { 'actions.close', mode = 'n' },
      ['<C-l>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
    use_default_keymaps = true,
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        local m = name:match '^%.'
        return m ~= nil
      end,
      is_always_hidden = function(name, bufnr)
        return false
      end,
      natural_order = 'fast',
      case_insensitive = false,
      sort = {
        { 'type', 'asc' },
        { 'name', 'asc' },
      },
    },
    float = {
      padding = 3,
      max_width = 64,
      border = 'single',
      win_options = {
        winblend = 0,
      },
    },
    preview_win = {
      update_on_cursor_moved = true,
      preview_method = 'fast_scratch',
    },
    confirmation = {
      border = 'single',
    },
    progress = {
      border = 'single',
    },
    ssh = {
      border = 'single',
    },
    keymaps_help = {
      border = 'single',
    },
  },
}
