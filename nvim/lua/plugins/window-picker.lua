return {
    's1n7ax/nvim-window-picker',
    event = 'VeryLazy',
    version = '2.*',
    opts = {
        filter_rules = {
            include_current_win = true,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', 'neo-tree-popup', 'notify', 'neotest-summary', 'neotest-output' },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', 'quickfix', 'nofile', 'help' },
            },
        },
    },
}
