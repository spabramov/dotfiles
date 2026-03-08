return {

    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        keys = {
            {
                "<leader>ho",
                function()
                    MiniDiff.toggle_overlay(0)
                end,
            },
        },
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - ysiw) - [Y]ank [S]urround [I]nner [W]ord [)]Paren
            -- - ds'   - [D]elete [S]urround [']quotes
            -- - cs)'  - [C]hange [S]urround [)] [']
            require("mini.surround").setup({
                mappings = {
                    add = 'sa',     -- Add surrounding in Normal and Visual modes
                    delete = 'ds',  -- Delete surrounding
                    replace = 'cs', -- Replace surrounding
                }
            })

            require("mini.statusline").setup()
            require("mini.git").setup()
            require("mini.diff").setup()
        end,
    },
}
