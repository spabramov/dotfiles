-- Mason PATH is handled by core.mason-path
vim.lsp.enable({
  "lua_ls",
  "rust-analyzer",
  "pyright",
  "ruff",
  "dockerls",
})

vim.diagnostic.config({
  virtual_text = false, -- managed by "tiny-inline-diagnostics"
  -- {
  --   format = function(diagnostic)
  --     return string.format("%s [%s]", diagnostic.message, diagnostic.source)
  --   end,
  -- },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

-- Extras

local function check_lsp_capabilities()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    print("No LSP clients attached")
    return
  end

  for _, client in ipairs(clients) do
    print("Capabilities for " .. client.name .. ":")
    local caps = client.server_capabilities

    local capability_list = {
      { "Completion", caps.completionProvider },
      { "Hover", caps.hoverProvider },
      { "Signature Help", caps.signatureHelpProvider },
      { "Go to Definition", caps.definitionProvider },
      { "Go to Declaration", caps.declarationProvider },
      { "Go to Implementation", caps.implementationProvider },
      { "Go to Type Definition", caps.typeDefinitionProvider },
      { "Find References", caps.referencesProvider },
      { "Document Highlight", caps.documentHighlightProvider },
      { "Document Symbol", caps.documentSymbolProvider },
      { "Workspace Symbol", caps.workspaceSymbolProvider },
      { "Code Action", caps.codeActionProvider },
      { "Code Lens", caps.codeLensProvider },
      { "Document Formatting", caps.documentFormattingProvider },
      { "Document Range Formatting", caps.documentRangeFormattingProvider },
      { "Rename", caps.renameProvider },
      { "Folding Range", caps.foldingRangeProvider },
      { "Selection Range", caps.selectionRangeProvider },
    }

    for _, cap in ipairs(capability_list) do
      local status = cap[2] and "✓" or "✗"
      print(string.format("  %s %s", status, cap[1]))
    end
    print("")
  end
end

vim.api.nvim_create_user_command("LspCapabilities", check_lsp_capabilities, { desc = "Show LSP capabilities" })
