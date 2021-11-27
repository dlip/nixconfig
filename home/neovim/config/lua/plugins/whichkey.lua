local g = vim.g -- global variables

g.which_key_timeout = 100
local wk = require("whichkey_setup")

require("whichkey_setup").config({
  hide_statusline = false,
  default_keymap_settings = { silent = true, noremap = true },
  default_mode = "n",
})

local keymap = {
  ["<Tab>"] = { "<C-^>", "Previous Buffer" },
  b = { "<cmd>Telescope buffers<CR>", "Find Buffers" },
  d = {
    name = "+Debug",
    c = { '<cmd>lua require"dap".continue()<CR>', "Continue" },
    o = { '<cmd>lua require"dap".step_over()<CR>', "Step Over" },
    i = { '<cmd>lua require"dap".step_into()<CR>', "Step Into" },
    t = { '<cmd>lua require"dap".step_out()<CR>', "Step Out" },
    b = { '<cmd>lua require"dap".toggle_breakpoint()<CR>', "Toggle Breakpoint" },
    B = {
      "<cmd>lua require\"dap\".set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      "Toggle Breakpoint Condition",
    },
    l = {
      "<cmd>lua require\"dap\".set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      "Toggle Breakpoint Log",
    },
    r = { '<cmd>lua require"dap".repl.open()<CR>', "Open REPL" },
    e = { '<cmd>lua require"dap".run_last()<CR>', "Run Last" },
    u = { '<cmd>lua require"dapui".toggle()<CR>', "Toggle DAP UI" },
  },
  f = {
    name = "+Find",
    b = { "<cmd>Telescope buffers<CR>", "Buffers" },
    c = {
      name = "+Commands",
      c = { "<cmd>Telescope commands<CR>", "commands" },
      h = { "<cmd>Telescope command_history<CR>", "history" },
    },
    g = {
      name = "+Git",
      b = { "<cmd>Telescope git_branches<CR>", "branches" },
      c = { "<cmd>Telescope git_bcommits<CR>", "bcommits" },
      g = { "<cmd>Telescope git_commits<CR>", "commits" },
      s = { "<cmd>Telescope git_status<CR>", "status" },
    },
    f = { "<cmd>Telescope fd<CR>", "Find Files" },
    h = { "<cmd>Telescope help_tags<CR>", "help tags" },
    m = { "<cmd>Telescope man_pages<CR>", "man pages" },
    p = { "<cmd>Telescope frecency frecency default_text=:CWD:<CR>", "Find Recent Files" },
    q = { "<cmd>Telescope quickfix<CR>", "quickfix" },
    r = { "<cmd>Telescope frecency frecency default_text=:CWD:<CR>", "Find Recent Files" },
    t = { "<cmd>Telescope live_grep<CR>", "Text" },
  },
  g = {
    name = "+Git",
    b = { '<cmd>lua require"gitsigns".blame_line(true)<CR>', "Blame Line" },
    c = { "<cmd>Neogit commit<CR>", "Commit" },
    d = { "<cmd>DiffviewOpen<CR>", "Diffview Open" },
    D = { "<cmd>DiffviewClose<CR>", "Diffview Close" },
    f = { "<cmd>!git fetch --all --prune --jobs=10<CR>", "Fetch" },
    g = {
      name = "+Git Signs",
      s = { '<cmd>lua require"gitsigns".stage_hunk()<CR>', "Stage Hunk" },
      u = { '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', "Undo Stage Hunk" },
      r = { '<cmd>lua require"gitsigns".reset_hunk()<CR>', "Reset Hunk" },
      R = { '<cmd>lua require"gitsigns".reset_buffer()<CR>', "Reset Buffer" },
      p = { '<cmd>lua require"gitsigns".preview_hunk()<CR>', "Preview Hunk" },
      S = { '<cmd>lua require"gitsigns".stage_buffer()<CR>', "Stage Buffer" },
      U = { '<cmd>lua require"gitsigns".reset_buffer_index()<CR>', "Reset Buffer Index" },
    },
    h = { "<cmd>DiffviewFileHistory<CR>", "Diffview File History" },
    m = { "<cmd>MergetoolToggle<CR>", "Mergetool Toggle" },
    s = { "<cmd>Neogit<CR>", "Neogit Status" },
    t = { "<cmd>G<CR>", "Status" },
    p = { "<cmd>Neogit push<CR>", "Push" },
    l = { "<cmd>Neogit pull<CR>", "Pull" },
    o = { "<cmd><CR>", "Pull" },
    q = { "<cmd>Git mergetool<CR>", "Merge List Quickfix" },
    [","] = { "[c", "Previous change" },
    ["."] = { "]c", "Next change" },
  },
  l = {
    name = "+LSP",
    a = { "<cmd>Telescope lsp_code_actions<CR>", "Code Action" },
    d = { "<cmd>Telescope lsp_definitions<CR>", "Go to Definition(s)" },
    D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to Declaration" },
    e = { "<cmd>!eslint_d --fix %<CR>", "ESLint Fix Current File" },
    f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Buffer" },
    h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Trigger Hover" },
    H = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
    i = { "<cmd>Telescope lsp_implementations<CR>", "Go to Implementations" },
    l = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show Line Diagnostics" },
    m = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    n = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Go to Next Error" },
    N = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "Go to Previous Error" },
    q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "Set Loclist" },
    r = { "<cmd>Telescope lsp_references<CR>", "References" },
    s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Dynamic Workspace Symbols" },
    t = { "<cmd>Telescope lsp_type_definitions<CR>", "Type Definitions" },
    w = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace Folder" },
    W = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List Workspace Folders" },
    x = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Workspace Folder" },
  },
  n = { "<cmd>NvimTreeToggle<CR>", "NvimTreeToggle" },
  p = { "<cmd>Telescope fd<CR>", "Find Files" },
  s = { "<cmd>w!<CR>", "save file" }, -- set a single command and text
  t = {
    name = "+Test",
    d = { "<cmd>call DebugNearest()<CR>", "Debug Nearest" },
    f = { "<cmd>TestFile<CR>", "Test File" },
    l = { "<cmd>TestLast<CR>", "Test Last" },
    n = { "<cmd>TestNearest<CR>", "Test Nearest" },
    s = { "<cmd>TestSuite<CR>", "Test Suite" },
    v = { "<cmd>TestVisit<CR>", "Test Visit" },
  },
  q = {
    name = "+Quickfix",
    o = { "<cmd>copen<CR>", "Open" },
    c = { "<cmd>ccl<CR>", "Close" },
    n = { "<cmd>cn<CR>", "Next" },
    p = { "<cmd>cp<CR>", "Previous" },
  },
  x = { "<cmd>Bdelete<CR>", "Close Buffer" },
}

local plug = {
  r = {
    name = "+Rest",
    e = { "<Plug>RestNvim", "Execute" },
    p = { "<Plug>RestNvimPreview", "Preview" },
    l = { "<Plug>RestNvimLast", "Re-run last" },
  },
  w = {
    name = "+VimWiki",
    w = { "<Plug>VimwikiIndex", "Wiki Index" },
    i = { "<Plug>VimwikiDiaryIndex", "Diary Index" },
    s = { "<Plug>VimwikiUISelect", "Select Wiki" },
    t = { "<Plug>VimwikiTabIndex", "Index in New Tab" },
    g = { "<Plug>VimwikiDiaryGenerateLinks", "Generate Diary Links" },
    o = { "<Plug>VimwikiMakeTomorrowDiaryNote", "Diary Tomorrow" },
    D = { "<Plug>VimwikiTabMakeDiaryNote", "Diary Today in New Tab" },
    d = { "<Plug>VimwikiMakeDiaryNote", "Diary Today" },
    y = { "<Plug>VimwikiMakeYesterdayDiaryNote", "Diary Yesterday" },
  },
}

wk.register_keymap("leader", keymap)
wk.register_keymap("leader", plug, { silent = true, noremap = false })

function _G.package_json_mappings()
  local buffKeymap = {
    s = { '<cmd>lua require"package-info".show()<CR>', "Show package versions" },
    c = { '<cmd>lua require"package-info".hide()<CR>', "Hide package versions" },
    u = { '<cmd>lua require"package-info".update()<CR>', "Update package on line" },
    d = { '<cmd>lua require"package-info".delete()<CR>', "Delete package on line" },
    i = { '<cmd>lua require"package-info".install()<CR>', "Install a new package" },
    r = { '<cmd>lua require"package-info".reinstall()<CR>', "Reinstall dependencies" },
    p = { '<cmd>lua require"package-info".change_version()<CR>', "Install a different package version" },
  }
  wk.register_keymap(",", buffKeymap, { buffer = vim.api.nvim_get_current_buf() })
end
