-- debug.lua

-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  {
    -- NOTE: Yes, you can install new plugins here!
    "mfussenegger/nvim-dap",
    lazy = true,
    -- NOTE: And you can specify dependencies as well
    dependencies = {

      -- Required dependency for nvim-dap-ui
      "nvim-neotest/nvim-nio",
      -- Creates a beautiful debugger UI
      {
        "rcarriga/nvim-dap-ui",

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        opts = {
          -- Set icons to characters that are more likely to work in every terminal.
          --    Feel free to remove or use ones that you like more! :)
          --    Don't feel like these are good choices.
          icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
          controls = {
            icons = {
              pause = "⏸",
              play = "▶",
              step_into = "⏎",
              step_over = "⏭",
              step_out = "⏮",
              step_back = "b",
              run_last = "▶▶",
              terminate = "⏹",
              disconnect = "⏏",
            },
          },
        },
      },

      -- Installs the debug adapters for you
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",

      -- Add your own debuggers here
      { "mfussenegger/nvim-dap-python", lazy = true },
    },
    -- stylua: ignore
    keys ={
        { "<F1>", function() require("dap").step_into() end, desc = "Step Into" },
        { "<F2>", function() require("dap").step_over() end, desc = "Step Over" },
        { "<F3>", function() require("dap").step_out() end, desc = "Step Out" },
        { "<F5>", function() require("dap").continue() end, desc = "Continue" },
        { "<F7>", function() require("dapui").toggle() end, desc = "Debug: See last session result." },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
        { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
        { "<leader>dj", function() require("dap").down() end, desc = "Down" },
        { "<leader>dk", function() require("dap").up() end, desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
        { "<leader>ds", function() require("dap").session() end, desc = "Session" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      vim.fn.sign_define("DapBreakpoint", { text = "⏺", texthl = "Conditional", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Conditional", linehl = "", numhl = "" })
      -- Install golang specific config
      require("dap-python").setup()
    end,
  },
}
