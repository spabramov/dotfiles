return {
    'rmagatti/auto-session',
    enabled = false,
    config = function()
        vim.keymap.set('n', '<leader>wr', '<cmd>SessionRestore<cr>', { desc = '[W]orkspace [R]estore' })
        vim.keymap.set('n', '<leader>ws', '<cmd>SessionSave<cr>', { desc = '[W]orkspace [S]ave' })

        require('auto-session').setup {
            log_level = 'error',
            auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            auto_restore_enabled = false,
        }
    end,
}
