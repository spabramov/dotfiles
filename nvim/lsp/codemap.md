# lsp/

## Responsibility

- Houses per-language LSP configuration snippets consumed when `lspconfig` sets up servers.
- Encapsulates server-specific defaults (Lua diagnostics, workspace library, telemetry and custom `basedpyright` analysis overrides) so that editor setups stay declarative and modular.

## Design Patterns (if any)

- Each file is a minimal Lua module returning a `vim.lsp.Config`–shaped table with a `settings` block.  This keeps the configuration composable and easy to merge into `require('lspconfig').lua_ls.setup(...)` or similar calls.
- Settings are expressed directly in plain Lua tables (no helper functions) for clarity and to mirror the shape expected by the upstream LSP servers.

## Data & Control Flow

- When an LSP server is initialized, the editor loads the matching module from `lsp/` and passes its table to `lspconfig`.  That table is sent verbatim as the `settings` payload during initialize/configure.
- `lua_ls.lua` augments diagnostics by whitelisting `vim`, exposes the entire Neovim runtime (`vim.api.nvim_get_runtime_file`), and disables telemetry, so the flow is from runtime introspection into the Lua server settings.
- `basedpyright.lua` shapes Python analysis parameters (type checking mode, diagnostic overrides, selective inlay hints) so control flows from this file into the language server's analyzer before it reports diagnostics to buffers.

## Integration Points

- Consumed by whichever module boots Neovim LSP servers (likely `lua/core/lsp.lua` or a plugin spec) via `require('lsp.lua_ls')`, `require('lsp.basedpyright')`, etc.
- `lua_ls.lua` relies on the Neovim runtime API to construct workspace libraries, meaning it bridges `vim.api` and the external `lua-language-server` expectations.
- `basedpyright.lua` integrates with `nvim-lspconfig`'s Pyright setup and indirectly affects Python tooling (diagnostics, inlay hints) across the configuration.
