require("bufferline").setup{
  options = {
    custom_filter = function(buf_number)
      if string.match(vim.fn.bufname(buf_number), '^term://.*$') then
        return false
      end

      return true
    end,
  },
}
