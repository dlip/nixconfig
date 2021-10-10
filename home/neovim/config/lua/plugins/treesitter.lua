require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gv",
      node_incremental = "v",
      scope_incremental = "grc",
      node_decremental = "V",
    },
  },
  indent = {
    enable = true
  }
}
