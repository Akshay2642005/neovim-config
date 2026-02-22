---@diagnostic disable: undefined-field
local M = {}

--- @param client vim.lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
  local req = client.request

  client.request = function(self, method, params, handler, bufnr_req)
    if method == 'textDocument/definition' then
      return req(
        self,
        method,
        params,
        require('configs.lsp.handlers').go_to_definition,
        bufnr_req
      )
    else
      return req(self, method, params, handler, bufnr_req)
    end
  end

  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  --- @param lhs string
  --- @param rhs string|function
  --- @param desc string
  --- @param mode? string|string[]
  local function keymap(lhs, rhs, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = desc,
    })
  end

  -- ============================================================================
  -- Diagnostics
  -- ============================================================================
  keymap('<C-w>d', vim.diagnostic.open_float, 'Show diagnostic float')
  keymap('[d', function()
    vim.diagnostic.jump { count = -1, float = true }
  end, 'Previous diagnostic')
  keymap(']d', function()
    vim.diagnostic.jump { count = 1, float = true }
  end, 'Next diagnostic')
  keymap("<F2>", vim.diagnostic.setloclist, 'Diagnostics to loclist')

  -- ============================================================================
  -- Navigation
  -- ============================================================================
  keymap('gd', vim.lsp.buf.definition, 'Go to definition')
  keymap('gi', ':SnacksPickerLspImplementations<cr>', 'Go to implementation')
  keymap('gr', ':SnacksPickerLspReferences<cr>', 'Go to references')

  -- ============================================================================
  -- Documentation
  -- ============================================================================
  keymap('J', vim.lsp.buf.hover, 'Hover documentation')
  keymap('K', vim.lsp.buf.signature_help, 'Signature help')

  -- ============================================================================
  -- Workspace
  -- ============================================================================
  keymap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder')
  keymap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder')
  keymap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, 'List workspace folders')

  -- ============================================================================
  -- Symbols
  -- ============================================================================
  keymap('<leader>cd', vim.lsp.buf.type_definition, 'Type definition')
  keymap('<leader>cs', ':SnacksPickerLspDocumentSymbols<cr>', 'Document symbols')
  keymap('<leader>cw', ':SnacksPickerLspWorkspaceSymbols<cr>', 'Workspace symbols')

  -- ============================================================================
  -- Refactoring
  -- ============================================================================
  keymap('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')

  -- ============================================================================
  -- Conditional Keymaps (based on server capabilities)
  -- ============================================================================
  if client:supports_method 'textDocument/codeAction' then
    keymap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    keymap('<leader>oi', function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { 'source.organizeImports' },
          diagnostics = {},
        },
      }
    end, 'Organize imports')
  end

  if client:supports_method 'textDocument/declaration' then
    keymap('gD', vim.lsp.buf.declaration, 'Go to declaration')
  end

  if client:supports_method 'textDocument/documentHighlight' then
    local augroup = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = augroup,
      desc = 'Highlight references under the cursor',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = augroup,
      desc = 'Clear highlight references after move cursor',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end



  if client:supports_method 'textDocument/inlayHint' then
    keymap('<leader>ci', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, 'Toggle inlay hints')
  end
end

function M.setup_diagnostic_config()
  local severity_strings = {
    [1] = 'error',
    [2] = 'warn',
    [3] = 'info',
    [4] = 'hint',
  }

  vim.diagnostic.config {
    underline = true,
    virtual_text = {
      source = false,
      spacing = 1,
      suffix = '',
      format = function(diagnostic)
        return string.format(
          '%s: %s: %s ',
          severity_strings[diagnostic.severity],
          diagnostic.source,
          diagnostic.message
        )
      end,
    },
    signs = false,
    float = { source = true },
    update_in_insert = false,
    severity_sort = true,
  }
end

return M
