-- https://github.com/lukas-reineke/indent-blankline.nvim

require("indent_blankline").setup({
  char = "|",
  buftype_exclude = { "terminal" },
  show_current_context = true,
  filetype_exclude = {
    "help",
    "terminal",
    "dashboard",
    "packer",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
  },
  use_treesitter = true,
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
})
