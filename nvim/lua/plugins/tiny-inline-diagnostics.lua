return {
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        priority = 1000, -- needs to be loaded in first
        config = function()
            vim.diagnostic.config({
                virtual_text = false, -- managed by "tiny-inline-diagnostics"
                -- {
                --   format = function(diagnostic)
                --     return string.format("%s [%s]", diagnostic.message, diagnostic.source)
                --   end,
                -- },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = true,
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                        [vim.diagnostic.severity.WARN] = "WarningMsg",
                    },
                },
            })
            require("tiny-inline-diagnostic").setup({
                options = {
                    -- Display the source of the diagnostic (e.g., basedpyright, vsserver, lua_ls etc.)
                    show_source = {
                        enabled = true,
                        if_many = false,
                    },
                    use_icons_from_diagnostic = true,
                    show_all_diags_on_cursorline = true,
                    multilines = {
                        enabled = false,
                        always_show = false,
                    },
                    throttle = 20,

                    overwrite_events = { "BufReadPost" },
                },
            })
        end,
    },
}
