require'lualine'.setup {
  extensions = {'nvim-tree', 'quickfix'},
  sections = {
    lualine_a = {
      'mode',
    },
    lualine_b = {
      'branch',
    },
    lualine_c = {
      {'filename', file_status = true, path = 1},
      {'diagnostics', sources = {'nvim_lsp'}},
      {require'lsp-status'.status, left_padding = 3},
    },
    lualine_x = {
      'diff',
      'encoding',
      'fileformat',
      'filetype',
    },
    lualine_y = {
      'progress',
    },
    lualine_z = {
      'location',
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {'filename', file_status = true, path = 1},
    },
    lualine_x = {
      'location',
    },
    lualine_y = {},
    lualine_z = {}
  },
}
