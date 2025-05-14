return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
        -- adapters

        'nvim-neotest/neotest-python',
    },
    keys = {
        { '<leader>tt', '<cmd>Neotest summary<cr>', desc = 'Neo[T]est [T]ree' },
        { '<leader>tr', '<cmd>Neotest run<cr>', desc = 'Neo[T]est [R]un nearest test' },
        { '<leader>td', '<cmd>Neotest run strategy=dap<cr>', desc = 'Neo[T]est [D]ebug nearest test' },
        { '<leader>tw', '<cmd>Neotest output<cr>', desc = 'Neo[T]est output [W]idget' },
        {
            '<leader>tR',
            function()
                require('neotest').run.run(vim.fn.expand '%')
            end,
            desc = 'Neo[T]est [R]un ALL test in current file',
        },
    },
    config = function()
        local opts = {
            adapters = {
                require 'neotest-python' {
                    dap = { justMyCode = false },
                    runner = 'pytest',
                    args = { '--log-level', 'DEBUG' },
                },
            },
        }
        require('neotest').setup(opts)
    end,
}
