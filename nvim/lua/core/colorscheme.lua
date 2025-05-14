return {
    -- { -- You can easily change to a different colorscheme.
    --   -- Change the name of the colorscheme plugin below, and then
    --   -- change the command in the config to whatever the name of that colorscheme is.
    --   --
    --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    --   'ellisonleao/gruvbox.nvim',
    --   dependencies = {
    --     'm-demare/hlargs.nvim',
    --     enabled = true,
    --     ft = { 'python' },
    --     config = function()
    --       require('hlargs').setup {
    --         paint_arg_declarations = false,
    --       }
    --     end,
    --   },
    --   priority = 1000, -- Make sure to load this before all the other start plugins.
    --   opts = {
    --     bold = true,
    --     contrast = 'soft',
    --   },
    --   init = function()
    --     -- Load the colorscheme here.
    --     -- Like many other themes, this one has different styles, and you could load
    --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    --     vim.cmd.colorscheme 'gruvbox'
    --
    --     -- You can configure highlights by doing something like:
    --     -- vim.cmd.hi 'Comment gui=none'
    --   end,
    -- },
    {
        'folke/tokyonight.nvim',
        lazy = false,
        enabled = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd [[colorscheme tokyonight]]
        end,
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        enabled = true,
        priority = 1000,
        config = function()
            require('catppuccin').setup {
                flavour = 'mocha',
            }

            vim.cmd.colorscheme 'catppuccin'
        end,
    },
    -- lazy
    {
        'mhartington/oceanic-next',
        enabled = false,
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme OceanicNext]]

            vim.cmd.hi('clear', '@constructor')
            vim.cmd.hi('link', '@constructor', '@type')
        end,
    },
    {
        'nordtheme/vim',
        enabled = false,
        config = function()
            vim.cmd.colorscheme 'nord'
        end,
    },
    {
        'sainnhe/everforest',
        enabled = false,
        config = function()
            vim.cmd.colorscheme 'everforest'
        end,
    },
    -- {
    --   'sainnhe/gruvbox-material',
    --   config = function()
    --     vim.cmd.colorscheme 'gruvbox-material'
    --   end,
    -- },
}
