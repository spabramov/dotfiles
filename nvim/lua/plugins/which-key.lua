return {                -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
        local which_key = require 'which-key'
        which_key.setup({
            preset = "helix"
        })

        -- Document existing key chains
        which_key.add {
            { "<leader>c",  group = "[C]ode" },
            { "<leader>c_", hidden = true },
            { "<leader>d",  group = "[D]ocument" },
            { "<leader>d_", hidden = true },
            { "<leader>s",  group = "[S]earch" },
            { "<leader>s_", hidden = true },
            { "<leader>w",  group = "[W]orkspace" },
            { "<leader>w_", hidden = true },
        }
    end,
}
