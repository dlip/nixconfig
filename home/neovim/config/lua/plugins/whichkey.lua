local g = vim.g -- global variables
local gs = require"gitsigns"

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
    align = "center", -- align columns left, center or right
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
  f = {
    name = "Find",
    b = { "<cmd>Telescope buffers<CR>", "Buffers" },
    c = { "<cmd>Telescope commands<CR>", "commands" },
    C = { "<cmd>Telescope command_history<CR>", "history" },
    f = { "<cmd>Telescope fd<CR>", "Find Files" },
    h = { "<cmd>Telescope help_tags<CR>", "help tags" },
    m = { "<cmd>Telescope man_pages<CR>", "man pages" },
    p = { "<cmd>Telescope frecency frecency default_text=:CWD:<CR>", "Find Recent Files" },
    q = { "<cmd>Telescope quickfix<CR>", "quickfix" },
    r = { "<cmd>Telescope frecency frecency default_text=:CWD:<CR>", "Find Recent Files" },
    t = { "<cmd>Telescope live_grep<CR>", "Text" },
  },
  g = {
    name = "Git",
    b = { function() gs.blame_line{full=true} end, "Blame Line" },
    B = { "<cmd>Telescope git_branches<CR>", "Branches" },
    c = { "<cmd>Neogit commit<CR>", "Commit" },
    C = { "<cmd>Telescope git_commits<CR>", "Commit History" },
    d = { "<cmd>DiffviewOpen<CR>", "Diffview Open" },
    D = { "<cmd>DiffviewClose<CR>", "Diffview Close" },
    f = { "<cmd>!git fetch --all --prune --jobs=10<CR>", "Fetch" },
    g = {
      name = "Git Signs",
      s = { function() gs.stage_hunk() end, "Stage Hunk" },
      u = { function() gs.undo_stage_hunk() end, "Undo Stage Hunk" },
      r = { function() gs.reset_hunk() end, "Reset Hunk" },
      R = { function() gs.reset_buffer() end, "Reset Buffer" },
      p = { function() gs.preview_hunk() end, "Preview Hunk" },
      S = { function() gs.stage_buffer() end, "Stage Buffer" },
      U = { function() gs.reset_buffer_index() end, "Reset Buffer Index" },
    },
    h = { "<cmd>DiffviewFileHistory<CR>", "Diffview File History" },
    H = { "<cmd>Telescope git_bcommits<CR>", "Buffer Commits" },
    m = { "<cmd>MergetoolToggle<CR>", "Mergetool Toggle" },
    M = { "<cmd>Git mergetool<CR>", "Merge List Quickfix" },
    l = { "<cmd>Octo pr list<CR>", "List PR" },
    n = { "<cmd>Octo pr create<CR>", "Create PR" },
    s = { "<cmd>Neogit<CR>", "Neogit Status" },
    S = { "<cmd>Telescope git_status<CR>", "Telescope Status" },
    t = { "<cmd>G<CR>", "Status" },
    p = { "<cmd>Neogit pull<CR>", "Pull" },
    P = { "<cmd>Neogit push<CR>", "Push" },
    q = { "<cmd>Git difftool<CR>", "Changes in Quickfix" },
    [","] = { "[c", "Previous change" },
    ["."] = { "]c", "Next change" },
  },
  n = { "<cmd>NvimTreeToggle<CR>", "NvimTreeToggle" },
  p = { "<cmd>Telescope fd<CR>", "Find Files" },
  s = { "<cmd>w!<CR>", "save file" }, -- set a single command and text
  q = {
    name = "Quickfix",
    o = { "<cmd>copen<CR>", "Open" },
    c = { "<cmd>ccl<CR>", "Close" },
    n = { "<cmd>cn<CR>", "Next" },
    p = { "<cmd>cp<CR>", "Previous" },
  },
  w = {
    name = "VimWiki",
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
  local dap = require"dap"
  local dapui = require"dapui"
  local buffKeymap = {
    a = { "<cmd>Telescope lsp_code_actions<CR>", "Code Action" },
    b = {
      name = "Debug",
      c = { function() dap.continue() end, "Continue" },
      o = { function() dap.step_over() end, "Step Over" },
      i = { function() dap.step_into() end, "Step Into" },
      t = { function() dap.step_out() end, "Step Out" },
      b = { function() dap.toggle_breakpoint() end, "Toggle Breakpoint" },
      B = {
        function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        "Toggle Breakpoint Condition",
      },
      l = {
        function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
        "Toggle Breakpoint Log",
      },
      r = { function() dap.repl.open() end, "Open REPL" },
      e = { function() dap.run_last() end, "Run Last" },
      u = { function() dapui.toggle() end, "Toggle DAP UI" },
    },
    d = { "<cmd>Telescope lsp_definitions<CR>", "Go to Definition(s)" },
    D = { function() vim.lsp.buf.declaration() end, "Go to Declaration" },
    f = { function() format_buffer() end, "Format Buffer" },
    F = { function() vim.lsp.buf.formatting() end, "LSP Format Buffer" },
    h = { function() vim.lsp.buf.hover() end, "Trigger Hover" },
    H = { function() vim.lsp.buf.signature_help() end, "Signature Help" },
    i = { "<cmd>Telescope lsp_implementations<CR>", "Go to Implementations" },
    l = { function() require('lint').try_lint() end, "Lint" },
    m = { function() vim.lsp.buf.rename() end, "Rename" },
    n = { function() vim.lsp.diagnostic.goto_next() end, "Go to Next Error" },
    N = { function() vim.lsp.diagnostic.goto_prev() end, "Go to Previous Error" },
    o = { function() vim.lsp.diagnostic.show_line_diagnostics() end, "Show Line Diagnostics" },
    q = { function() vim.lsp.diagnostic.set_loclist() end, "Set Loclist" },
    r = { "<cmd>Telescope lsp_references<CR>", "References" },
    s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Dynamic Workspace Symbols" },
    t = {
      name = "Test",
      b = { "<cmd>DlvToggleBreakpoint<CR>", "Toggle Breakpoint" },
      d = { "<cmd>call DebugNearest()<CR>", "Debug Nearest" },
      f = { "<cmd>TestFile<CR>", "Test File" },
      k = { "<cmd>AsyncStop<CR>", "Kill Running Test" },
      l = { "<cmd>TestLast<CR>", "Test Last" },
      n = { "<cmd>TestNearest<CR>", "Test Nearest" },
      s = { "<cmd>TestSuite<CR>", "Test Suite" },
      v = { "<cmd>TestVisit<CR>", "Test Visit" },
    },
    w = { function() vim.lsp.buf.add_workspace_folder() end, "Add Workspace Folder" },
    W = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders" },
    x = { function() vim.lsp.buf.remove_workspace_folder() end, "Remove Workspace Folder" },
    y = { "<cmd>Telescope lsp_type_definitions<CR>", "Type Definitions" },
  }
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end

function _G.json_mappings()
  local buffKeymap = {
    f = { function() format_buffer() end, "Format Buffer" },
  }
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end

function _G.package_json_mappings()
  local pi = require"package-info"
  local buffKeymap = {
    c = { function() pi.hide() end, "Hide package versions" },
    d = { function() pi.delete() end, "Delete package on line" },
    i = { function() pi.install() end, "Install a new package" },
    p = { function() pi.change_version() end, "Install a different package version" },
    r = { function() pi.reinstall() end, "Reinstall dependencies" },
    s = { function() pi.show() end, "Show package versions" },
    u = { function() pi.update() end, "Update package on line" },
  }
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end

function _G.http_mappings()
  local buffKeymap = {
    e = { "<Plug>RestNvim", "Execute" },
    p = { "<Plug>RestNvimPreview", "Preview" },
    l = { "<Plug>RestNvimLast", "Re-run last" },
  }
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end

function _G.octo_pr_mappings()
  local buffKeymap = {
    a = { "<cmd>Octo assignee add <CR>", "Add Assignee" },
    A = { "<cmd>Octo assignee remove <CR>", "Remove Assignee" },
    B = {
      name = "Label",
      a = { "<cmd>Octo label add<CR>", "Add Label" },
      r = { "<cmd>Octo label remove <CR>", "Remove Label" },
      c = { "<cmd>Octo label create <CR>", "Create Label" },
    },
    b = { "<cmd>Octo pr browser<CR>", "Open in browser" },
    c = {
      name = "Comment",
      a = { "<cmd>Octo comment add<CR>", "Add Comment" },
      d = { "<cmd>Octo comment delete<CR>", "Delete Comment" },
    },
    d = { "<cmd>Octo pr diff<CR>", "Diff" },
    e = {
      name = "Emoji",
      c = { "<cmd>Octo reaction confused<CR>", "😕 Confused" },
      d = { "<cmd>Octo reaction thumbs_down<CR>", "👎 Thumbs Down" },
      e = { "<cmd>Octo reaction eyes<CR>", "👀 Eyes" },
      h = { "<cmd>Octo reaction heart<CR>", "❤️ Heart" },
      l = { "<cmd>Octo reaction laugh<CR>", "😄 Laugh" },
      r = { "<cmd>Octo reaction rocket<CR>", "🚀 Rocket" },
      t = { "<cmd>Octo reaction tada<CR>", "🎉 Tada" },
      u = { "<cmd>Octo reaction thumbs_up<CR>", "👍 Thumbs Up" },
    },
    l = { "<cmd>Octo pr list<CR>", "List" },
    m = { "<cmd>Octo pr merge<CR>", "Merge" },
    o = { "<cmd>Octo pr checkout<CR>", "Checkout" },
    r = { "<cmd>Octo pr reload<CR>", "Reload" },
    s = { "<cmd>Octo pr search<CR>", "Search" },
    u = { "<cmd>Octo pr reopen<CR>", "Reopen" },
    v = {
      name = "Reviewer",
      a = { "<cmd>Octo reviewer add<CR>", "Add Reviewer" },
      r = { "<cmd>Octo reviewer remove<CR>", "Remove Reviewer" },
    },
    X = { "<cmd>Octo pr close<CR>", "Close" },
    y = { "<cmd>Octo pr url<CR>", "Copy URL" },
  }
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end

function _G.markdown_mappings()
  local buffKeymap = {
    x = { "<Plug>(mkdx-checkbox-prev-n)", "Prev checkbox state" },
    X = { "<Plug>(mkdx-checkbox-next-n)", "Next checkbox state" },
    [","] = { "<Plug>(mkdx-promote-header)", "Promote header" },
    ["."] = { "<Plug>(mkdx-demote-header)", "Demote header" },
    q = { "<Plug>(mkdx-toggle-quote-n)", "Toggle quote" },
    c = { "<Plug>(mkdx-toggle-checklist-n)", "Toggle checklist item" },
    C = { "<Plug>(mkdx-toggle-checkbox-n)", "Toggle checkbox item" },
    t = { "<Plug>(mkdx-toggle-list-n)", "Toggle list item" },
    l = { "<Plug>(mkdx-wrap-link-n)", "Wrap link" },
    i = { "<Plug>(mkdx-text-italic-n)", "Italicize text" },
    b = { "<Plug>(mkdx-text-bold-n))", "Bolden text" },
    w = { "<Plug>(mkdx-text-inline-code-n)", "Wrap with inline code" },
    s = { "<Plug>(mkdx-text-strike-n)", "Wrap with strikethrough" },
    v = { "<Plug>(mkdx-tableize)", "CSV to table" },
    h = { "<Plug>(mkdx-jump-to-header)", "Jump to header" },
    g = { "<Plug>(mkdx-gen-or-upd-toc)", "Generate / Update TOC" },
    G = { "<Plug>(mkdx-quickfix-toc)", "Quickfix TOC" },
    f = { "<Plug>(mkdx-quickfix-links)", "Quickfix dead fragment links" },
    -- x = { "<Plug>(mkdx-o)", "<kbd>o</kbd> handler" },
    -- x = { "<Plug>(mkdx-shift-o)", "<kbd>O</kbd> handler" },
    -- x = { "<Plug>(mkdx-fence-backtick)", "Insert fenced code block" },
    -- x = { "<Plug>(mkdx-fence-tilde)", "Insert fenced code block" },
    -- x = { "<Plug>(mkdx-insert-kbd)", "Insert kbd shortcut" },
    -- x = { "<Plug>(mkdx-enter)", "<kbd>enter</kbd> handler" },
    -- x = { "<Plug>(mkdx-shift-enter)", "<kbd>shift</kbd>+<kbd>enter</kbd> handler" },
    -- x = { "<Plug>(mkdx-ctrl-n-compl)", "<kbd>ctrl</kbd>+<kbd>n</kbd> handler" },
    -- x = { "<Plug>(mkdx-ctrl-p-compl)", "<kbd>ctrl</kbd>+<kbd>p</kbd> handler" },
    -- x = { "<Plug>(mkdx-link-compl)", "<kbd>#</kbd> handler" },
    -- x = { "<Plug>(mkdx-gf)", "Jump to file" },
    -- x = { "<Plug>(mkdx-gf-visual)", "Jump to file" },
    -- x = { "<Plug>(mkdx-gx)", "Open external file" },
    -- x = { "<Plug>(mkdx-gx-visual)", "Open external file" },
    -- x = { "<Plug>(mkdx-indent)", "Indent numbered list item" },
    -- x = { "<Plug>(mkdx-unindent)", "Unindent numbered list item" },
    -- x = { "<Plug>(mkdx-jump-to-next-section)", "Jump to next header" },
    -- x = { "<Plug>(mkdx-jump-to-prev-section)", "Jump to prev header" },
  }
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end

function _G.quickfix_mappings()
  local buffKeymap = {
    f = { "<cmd>cfdo lua format_buffer()<CR><cmd>wa<CR>", "Format All" },
  }
  wk.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end
