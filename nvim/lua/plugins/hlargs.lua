return {
    {
        'm-demare/hlargs.nvim',
        enabled = true,
        name = 'hlargs',
        ft = { 'python' },
        config = function()
            require('hlargs').setup {
                paint_arg_declarations = false,
                excluded_argnames = {
                    declarations = {
                        python = { 'self', 'cls' },
                        lua = { 'self' },
                    },
                    usages = {
                        python = { 'self', 'cls' },
                        lua = { 'self' },
                    },
                },
            }
            --
            vim.cmd.hi('clear', 'Hlargs')
            vim.cmd.hi('link', 'Hlargs', '@variable.parameter')
            vim.cmd.hi('Hlargs', 'gui=bold')
        end,
    },
}
