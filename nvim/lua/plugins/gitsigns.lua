return {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    keys = {
        { '[h', '<cmd>Gitsigns nav_hunk prev<cr>', desc = 'Previous [H]unk' },
        { ']h', '<cmd>Gitsigns next_hunk next<cr>', desc = 'Next [H]unk' },
        { '|h', '<cmd>Gitsigns preview_hunk_inline<cr>', desc = 'Preview [H]unk' },
        { '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', desc = '[R]eset [H]unk' },
        { '<leader>ha', '<cmd>Gitsigns stage_hunk<cr>', desc = 'St[A]ge [H]unk' },
        { '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = '[U]ndo Stage [H]unk' },
        { '<leader>hA', '<cmd>Gitsigns stage_buffer<cr>', desc = 'Stage [A]ll [H]unks in buffer' },
    },
    opts = {
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
    },
}
