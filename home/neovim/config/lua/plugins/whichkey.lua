
local g = vim.g                 -- global variables

g.which_key_timeout = 100
local wk = require("whichkey_setup")

require("whichkey_setup").config {
    hide_statusline = false,
    default_keymap_settings = {silent = true, noremap = true},
    default_mode = 'n'
}

local keymap = {
    ['<Tab>'] = {'<C-^>', 'Previous Buffer'},
    f = {
        name = '+Find',
        b = {':Telescope buffers<CR>', 'buffers'},
        c = {
            name = '+Commands',
            c = {':Telescope commands<CR>', 'commands'},
            h = {':Telescope command_history<CR>', 'history'}
        },
        g = {':Telescope live_grep<CR>', 'grep'},
        h = {':Telescope help_tags<CR>', 'help tags'},
        m = {':Telescope man_pages<CR>', 'man pages'},
        q = {':Telescope quickfix<CR>', 'quickfix'},
        v = {
            name = '+VCS',
            b = {':Telescope git_branches<CR>', 'branches'},
            c = {':Telescope git_bcommits<CR>', 'bcommits'},
            g = {':Telescope git_commits<CR>', 'commits'},
            s = {':Telescope git_status<CR>', 'status'}
        },
    },
    g = {
        name = '+Git',
        s = {':Neogit<CR>', 'status'},
        p = {':Neogit push<CR>', 'push'},
        l = {':Neogit pull<CR>', 'pull'}
    },
    l = {
        name = '+LSP',
        c = {'<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action'},
        d = {'<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to Definition'},
        D = {'<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to Declaration'},
        e = {'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Show Line Diagnostics'},
        f = {'<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format Buffer'},
        h = {'<cmd>lua vim.lsp.buf.hover()<CR>', 'Trigger Hover'},
        i = {'<cmd>lua vim.lsp.buf.implementation()<CR>', 'Go to Implementation'},
        l = {'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'List Workspace Folders'},
        m = {'<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename'},
        n = {'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Go to Next Error'},
        N = {'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Go to Previous Error'},
        q = {'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Set Loclist'},
        r = {'<cmd>lua vim.lsp.buf.references()<CR>', 'References'},
        s = {'<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help'},
        t = {'<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type Definitions'},
        w = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add Workspace Folder'},
        x = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove Workspace Folder'},
    },
    p = {':Telescope fd<CR>', 'Find Files'},
    s = {':w!<CR>', 'save file'}, -- set a single command and text
    t = {':NvimTreeToggle<CR>', 'Tree'},
    w = {
        name = '+Window',
        h = {':sp<CR>', 'horizontal split window'},
        o = {'<C-W>o', 'other'},
        q = {'<C-W>q', 'close'},
        v = {':vsplit<CR>', 'vertical split window'}
    }
}

wk.register_keymap('leader', keymap)