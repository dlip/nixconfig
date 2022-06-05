require("ultest").setup({
  builders = {
    ['javascript#nx'] = function(cmd)
      local args = { cmd[4], cmd[5], cmd[7] }
      return {
        dap = {
          name = "Debug Jest tests",
          type = "node2",
          request = "launch",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          runtimeArgs = {
            "--inspect-brk",
            "node_modules/.bin/jest",
            "--runInBand"
          },
          protocol = 'inspector',
          console = 'integratedTerminal',
          args = args,
          port = 9229
        }
      }
    end
  }
})
