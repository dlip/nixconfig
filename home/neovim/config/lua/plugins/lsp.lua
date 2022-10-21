local nvim_lsp = require("lspconfig")
local null_ls = require("null-ls")
local g = vim.g
local lsp = vim.lsp

null_ls.setup({
  on_attach = require("lsp-format").on_attach,
  sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.diagnostics.vint,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.trim_whitespace,
    null_ls.builtins.formatting.gofmt.with({
      args = { "-s" },
    }),
    null_ls.builtins.diagnostics.vale.with({
      args = { "--config", "~/.config/vale/vale.ini", "--no-exit", "--output=JSON", "$FILENAME" },
    }),
  },
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "pyright",
  "rnix",
  "rust_analyzer",
  "solang",
  "terraformls",
  "tsserver",
  "vimls",
}

for _, server in ipairs(servers) do
  nvim_lsp[server].setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities(lsp.protocol.make_client_capabilities()),
    on_attach = require("lsp-format").on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

-- Sumneko lua-language-server setup

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local lib = vim.api.nvim_get_runtime_file("", true)
lib[g.awesome_root_path .. "/lib"] = true

require("lspconfig").sumneko_lua.setup({
  cmd = { g.sumneko_root_path .. "/bin/lua-language-server", "-E", g.sumneko_root_path .. "/extras/main.lua" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(lsp.protocol.make_client_capabilities()),
  on_attach = require("lsp-format").on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",
          -- AwesomeWM
          "awesome",
          "client",
          "root",
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
})

require("lsp_signature").setup({})
require("lsp-format").setup({
  typescript = {
    exclude = { "tsserver" },
  },
  javascript = {
    exclude = { "tsserver" },
  },
  typescriptreact = {
    exclude = { "tsserver" },
  },
  lua = {
    exclude = { "null-ls" },
  },
  terraform = {
    exclude = { "null-ls" },
  },
  html = {
    exclude = { "html" },
  },
  -- disable yaml
  yaml = {
    exclude = { "null-ls" },
  },
})

vim.cmd("FormatDisable")
