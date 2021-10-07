
local g = vim.g                 -- global variables

g.which_key_timeout = 100
local wk = require("whichkey_setup")

require("whichkey_setup").config {
    hide_statusline = false,
    default_keymap_settings = {silent = true, noremap = true},
    default_mode = 'n'
}

local keymap = {
    ['<CR>'] = {'@q', 'macro q'}, -- setting a special key
    f = { -- set a nested structure
        name = '+find',
        b = {'<Cmd>Telescope buffers<CR>', 'buffers'},
        c = {
            name = '+cormands',
            c = {'<Cmd>Telescope commands<CR>', 'commands'},
            h = {'<Cmd>Telescope command_history<CR>', 'history'}
        },
        g = {'<Cmd>Telescope live_grep<CR>', 'grep'},
        h = {'<Cmd>Telescope help_tags<CR>', 'help tags'},
        m = {'<Cmd>Telescope man_pages<CR>', 'help tags'},
        q = {'<Cmd>Telescope quickfix<CR>', 'quickfix'},
        v = {
            name = '+vcs',
            b = {'<Cmd>Telescope git_branches<CR>', 'branches'},
            c = {'<Cmd>Telescope git_bcommits<CR>', 'bcommits'},
            g = {'<Cmd>Telescope git_commits<CR>', 'commits'},
            s = {'<Cmd>Telescope git_status<CR>', 'status'}
        },
    },
    g = {
        name = '+git',
        s = {':Git<CR>', 'Git Status'},
        g = {':Neogit<CR>', 'Neogit'},
        p = {':Neogit push<CR>', 'push'}
    },
    n = {':NvimTreeToggle<CR>', 'NvimTree'},
    p = {'<Cmd>Telescope fd<CR>', 'buffers'},
    s = {':w!<CR>', 'save file'}, -- set a single command and text
    w = {
        name = '+window',
        f = {'<C-W>k', 'up'},
        h = {':sp<CR>', 'horizontal split window'},
        o = {'<C-W>o', 'other'},
        q = {'<C-W>q', 'close'},
        r = {'<C-W>h', 'left'},
        s = {'<C-W>j', 'down'},
        t = {'<C-W>l', 'right'},
        v = {':vsplit<CR>', 'vertical split window'}
    }
}

wk.register_keymap('leader', keymap)
