return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "echasnovski/mini.nvim",
            "folke/lazydev.nvim",
        },
        version = "1.*",
        opts = {
            keymap = {
                preset = "default",
                ['<C-b>'] = { 'show', 'show_documentation', 'hide_documentation' },
            },
            sources = {
                -- add lazydev to your completion providers
                default = { "lsp", "path", "snippets", "buffer" },
                per_filetype = {
                    lua = { inherit_defaults = true, "lazydev" },
                    md = { "buffer", "path" }
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                        columns = {
                            { "label",      "label_description", gap = 1 },
                            { "kind_icon" },
                            { "source_name" },
                        },
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return kind_icon
                                end,
                                -- (optional) use highlights from mini.icons
                                highlight = function(ctx)
                                    local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return hl
                                end,
                            },
                            kind = {
                                -- (optional) use highlights from mini.icons
                                highlight = function(ctx)
                                    local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                    return hl
                                end,
                            },
                        },
                    },
                },
                accept = {
                    auto_brackets = { enabled = false },
                },
                documentation = { auto_show = true },
            },
            cmdline = {
                enabled = true,
                completion = { menu = { auto_show = true } },
            },
            signature = { enabled = true, window = { border = "rounded" } },
        },
    },
}
