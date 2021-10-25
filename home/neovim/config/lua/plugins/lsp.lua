local nvim_lsp = require('lspconfig')

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  'bashls',
  'clangd',
  'cssls',
  'dockerls',
  'gopls',
  'html',
  'solang',
  'pyright',
  'rnix',
  'terraformls',
  'rust_analyzer',
  'tsserver'
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- Sumneko lua-language-server setup

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local lib = vim.api.nvim_get_runtime_file("", true)
lib[awesome_root_path .. "/lib"] = true

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_root_path .. "/bin/lua-language-server", "-E", sumneko_root_path .. "/extras/main.lua"};
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          -- AwesomeWM
          "awesome",
          "client",
          "root"
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = lib,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
