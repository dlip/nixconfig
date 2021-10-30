local g = vim.g

require("luasnip/loaders/from_vscode").lazy_load({ paths = { g.friendly_snippets_path } })
