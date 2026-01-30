return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'folke/ts-comments.nvim', opts = {} },
    },
    lazy = false,

    branch = 'main',
    build = function()
      -- update parsers, if TSUpdate exists
      if vim.fn.exists(':TSUpdate') == 2 then vim.cmd('TSUpdate') end
    end,

    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    ---@module 'nvim-treesitter'
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields

    config = function(_, _)
      local ensure_installed = {
        "bash",
        "c",
        "css",
        "diff",
        "gitcommit",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc",
        "sql",
        "python",
        "rust",
        "dockerfile",
        "nim_format_string",
      }

      -- make sure nvim-treesitter can load
      local ok, nvim_treesitter = pcall(require, 'nvim-treesitter')

      -- no nvim-treesitter, maybe fresh install
      if not ok then return end

      nvim_treesitter.install(ensure_installed)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",

    keys = {
      {
        'af',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@function.outer',
            'textobjects')
        end,
        desc = 'outer function',
        mode = { 'x', 'o' },
      },
      {
        'if',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@function.inner',
            'textobjects')
        end,
        desc = 'inner function',
        mode = { 'x', 'o' },
      },
      {
        'ac',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@class.outer',
            'textobjects')
        end,
        desc = 'outer class',
        mode = { 'x', 'o' },
      },
      {
        'ic',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@class.inner',
            'textobjects')
        end,
        desc = 'inner class',
        mode = { 'x', 'o' },
      },
      {
        'aa',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer',
            'textobjects')
        end,
        desc = 'outer argument',
        mode = { 'x', 'o' },
      },
      {
        'ia',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner',
            'textobjects')
        end,
        desc = 'inner argument',
        mode = { 'x', 'o' },
      },
    },

    opts = {
      move = {
        enable = true,
        set_jumps = true,
      },
      swap = {
        enable = true,
      },
    },
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function()
      -- put your config here
    end,
  }

}

-- vim: ts=2 sts=2 sw=2 et
