return {
  {
    "m-demare/hlargs.nvim",
    enabled = true,
    name = "hlargs",
    ft = { "python" },
    config = function()
      require("hlargs").setup({
        paint_arg_declarations = false,
        excluded_argnames = {
          declarations = {
            python = { "self", "cls" },
            lua = { "self" },
          },
          usages = {
            python = { "self", "cls" },
            lua = { "self" },
          },
        },
      })
      --
      vim.cmd.hi("clear", "Hlargs")
      vim.cmd.hi("link", "Hlargs", "@variable.parameter")
    end,
  },
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
    end,
  },
}
