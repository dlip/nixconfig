local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
    pattern = "markdown",
    callback = markdown_mappings,
    desc = "Markdown buffer mappings",
})

autocmd("FileType", {
    pattern = "json",
    callback = json_mappings,
    desc = "JSON buffer mappings",
})

autocmd("FileType", {
    pattern = "qf",
    callback = quickfix_mappings,
    desc = "Quickfix buffer mappings",
})

autocmd("FileType", {
    pattern = "sh,c,go,javascript,lua,nix,python,rust,typescript,typescriptreact,vim,yaml",
    callback = coding_mappings,
    desc = "Coding buffer mappings",
})

autocmd("FileType", {
    pattern = "http",
    callback = http_mappings,
    desc = "HTTP buffer mappings",
})

autocmd("BufEnter", {
    pattern = "package.json",
    callback = package_json_mappings,
    desc = "package.json buffer mappings",
})

autocmd("BufEnter", {
    pattern = "octo://*/pull/*",
    callback = octo_pr_mappings,
    desc = "Octo PR buffer mappings",
})
