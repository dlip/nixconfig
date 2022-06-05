require("ultest").setup({
  builders = {
    ['javascript#nx'] = function(cmd)
      print(vim.inspect(cmd))
      local args = vim.list_slice(cmd, 2)
      print(vim.inspect(args))

      local program = "${workspaceFolder}/" .. cmd[1]
      print(vim.inspect(program))
      return {
        dap = {
          type = "node2",
          request = "launch",
          program = program,
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = 'inspector',
          console = 'integratedTerminal',
          outFiles = { "${workspaceFolder}/dist/**/*.js" },
          sourceMapPathOverrides = {
            ["webpack://planpay/./*"] = "${workspaceFolder}/*",
          },
          args = args,
        }
      }
    end
  }
})
