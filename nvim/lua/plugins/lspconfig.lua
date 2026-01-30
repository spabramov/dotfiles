return {
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.enable({
                "lua_ls",
                "ruff",
                "docker_language_server",
                -- "rust_analyzer" -- activated by rusteaceanvim plugin
            })
        end
    },
}
