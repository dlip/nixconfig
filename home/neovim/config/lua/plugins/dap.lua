local dap = require("dap")
local dapui = require("dapui")

-- require("dap-go").setup()

dap.adapters.lldb = {
  type = "executable",
  command = "lldb-vscode",
  name = "lldb",
}

dap.configurations.typescript = {
  {
    type = "node2",
    name = "Attach",
    request = "attach",
    sourceMaps = true,
    sourceMapPathOverrides = {
      ["webpack://planpay/./*"] = "${workspaceFolder}/*",
    },
    port = 9229,
  },
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
    outFiles = { "${workspaceFolder}/dist/**/*.js" },
    sourceMapPathOverrides = {
      ["webpack://planpay/./*"] = "${workspaceFolder}/*",
    },
  },
  {
    type = "node2",
    name = "plan service",
    request = "attach",
    sourceMaps = true,
    -- trace = true,
    sourceMapPathOverrides = {
      ["webpack://planpay/./*"] = "${workspaceFolder}/*",
    },
    port = 9305,
  },
  {
    type = "chrome",
    name = "chrome",
    request = "attach",
    program = "${file}",
    -- cwd = "${workspaceFolder}",
    -- protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
    -- sourceMaps = true,
    sourceMapPathOverrides = {
      -- Sourcemap override for nextjs
      ["webpack://_N_E/./*"] = "${webRoot}/*",
      ["webpack:///./*"] = "${webRoot}/*",
    },
  },
}

dap.configurations.typescriptreact = dap.configurations.typescript
dap.configurations.javascript = dap.configurations.typescript
dap.configurations.javascriptreact = dap.configurations.typescript

-- dap.adapters.node2 = {
--   type = "executable",
--   command = "node",
--   args = {
--     vim.g.vscode_node_debug2_root_path .. "/out/src/nodeDebug.js",
--   },
-- }

dap.configurations.rust = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
