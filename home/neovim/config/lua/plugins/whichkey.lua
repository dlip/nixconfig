local g = vim.g -- global variables

g.which_key_timeout = 100
local wk = require("which-key")
require("which-key").setup({
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
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
    c = { "<cmd>Telescope commands<CR>", "commands" },
    C = { "<cmd>Telescope command_history<CR>", "history" },
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
    p = { "<cmd>Neogit pull<CR>", "Pull" },
    P = { "<cmd>Neogit push<CR>", "Push" },
    o = { "<cmd><CR>", "Pull" },
    q = { "<cmd>Git mergetool<CR>", "Merge List Quickfix" },
    [","] = { "[c", "Previous change" },
    ["."] = { "]c", "Next change" },
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
  x = { "<cmd>Bdelete<CR>", "Close Buffer" },
}

wk.register(keymap, { prefix = "<leader>" })

function _G.coding_mappings()
  local buffKeymap = {
    a = { "<cmd>Telescope lsp_code_actions<CR>", "Code Action" },
    d = { "<cmd>Telescope lsp_definitions<CR>", "Go to Definition(s)" },
    D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to Declaration" },
    e = { "<cmd>!eslint_d --fix %<CR>", "ESLint Fix Current File" },
    f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Buffer" },
    h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Trigger Hover" },
    H = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
    i = { "<cmd>Telescope lsp_implementations<CR>", "Go to Implementations" },
    l = { "<cmd>lua require('lint').try_lint()<CR>", "Lint" },
    m = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    n = { "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", "Go to Next Error" },
    N = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", "Go to Previous Error" },
    o = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show Line Diagnostics" },
    q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "Set Loclist" },
    r = { "<cmd>Telescope lsp_references<CR>", "References" },
    s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Dynamic Workspace Symbols" },
    t = { "<cmd>Telescope lsp_type_definitions<CR>", "Type Definitions" },
    w = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace Folder" },
    W = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List Workspace Folders" },
    x = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Workspace Folder" },
  }
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end

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
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end
