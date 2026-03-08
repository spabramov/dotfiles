return {
    { -- Linting
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            -- Extend this table to add more linters.
            local linters_by_ft = {
                python = { "mypy" },
                json = { "jsonlint" },
                markdown = { "markdownlint" },
                dockerfile = { "hadolint" },
                rust = { "clippy" },
            }

            lint.linters_by_ft = vim.tbl_extend("force", lint.linters_by_ft or {}, linters_by_ft)

            -- Create autocommand which carries out the actual linting
            -- on the specified events.
            local lint_augroup = vim.api.nvim_create_augroup("linting", { clear = true })
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint(nil, {
                        ignore_errors = true,
                        filter = function(linter)
                            if linter.name == "clippy" then
                                return vim.fn.executable("cargo") == 1
                            end

                            return vim.fn.executable(linter.cmd) == 1
                        end,
                    })
                end,
            })
        end,
    },
}
