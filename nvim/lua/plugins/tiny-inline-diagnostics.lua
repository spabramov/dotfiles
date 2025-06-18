return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    priority = 1000, -- needs to be loaded in first
    config = function()
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
            enabled = true,
            always_show = true,
          },

          overwrite_events = { "BufReadPost" },
        },
      })
    end,
  },
}
