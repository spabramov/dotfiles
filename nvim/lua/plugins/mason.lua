return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = { "Mason" },
    dependencies = {
      { "mason-org/mason-lspconfig.nvim" },
      { "jay-babu/mason-nvim-dap.nvim" },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
      require("mason-nvim-dap").setup()
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    lazy = true,
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = false,
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
  },
}
