local nvim_lsp = require('lspconfig')
local wk = require("whichkey_setup")
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local keymap = {
    l = {
        name = '+LSP',
        w = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add Workspace Folder'},
        x = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove Workspace Folder'},
        l = {'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List Workspace Folders'},
        d = {'<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type Definitions'},
        r = {'<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename'},
        c = {'<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action'},
        e = {'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Show Line Diagnostics'},
        q = {'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Set Loclist'},
        f = {'<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format Buffer'},
    },
  }
  wk.register_keymap('leader', keymap)
  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  'bashls',
  'clangd',
  'cssls',
  'dockerls',
  'gopls',
  'html',
  'pyright',
  'rnix',
  'terraformls',
  'rust_analyzer',
  'tsserver'
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
