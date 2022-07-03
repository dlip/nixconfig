require("neotest").setup({
  adapters = {
    require("neotest-plenary"),
    -- require("neotest-jest")({
    --   jestCommand = "npx nx test --",
    -- }),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
  },
})
