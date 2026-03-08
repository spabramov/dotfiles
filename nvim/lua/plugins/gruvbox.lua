return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                contrast = "hard",
                transparent_mode = false,
                italic = {
                    strings = false,
                    comments = false,
                    operators = false,
                    folds = false,
                    emphasis = false,
                },
            })
            vim.cmd.colorscheme("gruvbox")

            -- You can configure highlights by doing something like:
            vim.cmd.hi("clear", "SignColumn")
            vim.cmd.hi("clear", "DiagnosticSignOk")
            vim.cmd.hi("clear", "DiagnosticSignInfo")
            vim.cmd.hi("clear", "DiagnosticSignHint")
            vim.cmd.hi("clear", "DiagnosticSignWarn")
            vim.cmd.hi("clear", "DiagnosticSignError")
            vim.cmd.hi("link", "@sql.injected", "@text.emphasis")
            vim.cmd.hi("link", "@lsp.mod.mutable", "@text.underline")
        end,
    },
}
