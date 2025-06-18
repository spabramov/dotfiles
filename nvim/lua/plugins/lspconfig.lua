return {
  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    event = "LspAttach",
    dependencies = {
      { "williamboman/mason.nvim" },
    },
  },
}
