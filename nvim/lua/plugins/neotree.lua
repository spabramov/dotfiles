return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        's1n7ax/nvim-window-picker',
    },
    keys = {
        { '<leader>e', '<cmd>Neotree<cr>', desc = 'Open Neotree [E]xplorer' },
    },
    config = function()
        vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
        vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
        vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
        vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

        vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle file tree' })

        require('neo-tree').setup {
            source_selector = {
                winbar = true,
            },
            close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
            popup_border_style = 'rounded',
            window = {
                mappings = {
                    ['l'] = {
                        'toggle_node',
                        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
                    },
                    ['h'] = {
                        'close_node',
                        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
                    },
                },
            },
            filesystem = {
                filtered_items = {
                    always_show = { -- remains visible even if other settings would normally hide it
                        '.git',
                        '.vscode',
                        '.env',
                        '.env.example',
                        '.gitlab-ci.yml',
                        '.markdownlint.json',
                        '.taplo.toml',
                    },
                },
                follow_current_file = {
                    enabled = true, -- This will find and focus the file in the active buffer every time
                    --               -- the current file is changed while the tree is open.
                    leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                },
                use_libuv_file_watcher = false,
                hijack_netrw_behavior = 'open_default',
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = '✚', -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted = '✖', -- this can only be used in the git_status source
                    renamed = '󰁕', -- this can only be used in the git_status source
                    -- Status type
                    untracked = '',
                    ignored = '',
                    unstaged = '󰄱',
                    staged = '',
                    conflict = '',
                },
            },
        }
    end,
}
