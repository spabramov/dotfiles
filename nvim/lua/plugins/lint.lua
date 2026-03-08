return {
    { -- Linting
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = lint.linters_by_ft or {}
            lint.linters_by_ft["python"] = { "mypy" }
            lint.linters_by_ft["json"] = { "jsonlint" }
            lint.linters_by_ft["markdown"] = { "markdownlint" }
            lint.linters_by_ft["dokerfile"] = { "hadolint" }
            -- lint.linters_by_ft['text'] = { 'vale' }
            lint.linters_by_ft["rust"] = { "clippy" }

            -- lint.linters.pylint.cmd = "python"
            -- lint.linters.pylint.args = { "-m", "pylint", "-f", "json" }

            local mypy_linter = {
                cmd = "mypy",
                -- entry_point = { "mypy" },
                -- args = { "--incremental", "--no-color-output" },
                -- checks if the executable is available in the user's PATH
                condition = function(ctx)
                    print("aboba")
                    return vim.fn.exepath(ctx.linter.entry_point[1]) ~= ""
                end,
                -- ... other mypy specific configuration
            }
            -- lint.linters.mypy = mypy_linter

            -- To allow other plugins to add linters to require('lint').linters_by_ft,
            -- instead set linters_by_ft like this:
            -- lint.linters_by_ft = lint.linters_by_ft or {}
            -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
            --
            -- However, note that this will enable a set of default linters,
            -- which will cause errors unless these tools are available:
            -- {
            --   clojure = { "clj-kondo" },
            --   dockerfile = { "hadolint" },
            --   inko = { "inko" },
            --   janet = { "janet" },
            --   json = { "jsonlint" },
            --   markdown = { "vale" },
            --   rst = { "vale" },
            --   ruby = { "ruby" },
            --   terraform = { "tflint" },
            --   text = { "vale" }
            -- }
            --
            -- You can disable the default linters by setting their filetypes to nil:
            -- lint.linters_by_ft['clojure'] = nil
            -- lint.linters_by_ft['dockerfile'] = nil
            -- lint.linters_by_ft['inko'] = nil
            -- lint.linters_by_ft['janet'] = nil
            -- lint.linters_by_ft['json'] = nil
            -- lint.linters_by_ft['markdown'] = nil
            -- lint.linters_by_ft['rst'] = nil
            -- lint.linters_by_ft['ruby'] = nil
            -- lint.linters_by_ft['terraform'] = nil
            -- lint.linters_by_ft['text'] = nil

            -- Create autocommand which carries out the actual linting
            -- on the specified events.
            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
                group = lint_augroup,
                callback = function()
                    require("lint").try_lint(nil, { ignore_errors = true })
                end,
            })
            -- local lint_ns = vim.api.nvim_create_namespace("mypy")
            -- vim.diagnostic.config({
            --   virtual_text = {
            --     format = function(diagnostic)
            --       return string.format("%s [%s]", diagnostic.message, diagnostic.source)
            --     end,
            --   },
            -- })
        end,
    },
}
