
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
