# Repository Atlas: nvim

## Project Responsibility
Neovim configuration repository that bootstraps lazy.nvim, applies core editor options/keymaps/autocmds, and wires plugin and LSP behavior for the user's development environment.

## System Entry Points
- `init.lua`: Bootstraps lazy.nvim, loads core `options`, `keymaps`, `autocmd`, and initializes plugin specs.
- `lua/`: Core configuration modules (options, keymaps, autocmds) that run early and shape global editor behavior.
- `lua/plugins/`: Lazy.nvim plugin specs and configuration hooks.
- `lsp/`: Per-language LSP `settings` payloads consumed by `lspconfig`.
- `ftdetect/` and `syntax/`: Filetype detection and syntax highlighting definitions for custom filetypes.
- `stylua.toml`: Formatting rules for Lua code.
- `lazy-lock.json`: Locked plugin versions for reproducible setups.

## Directory Map (Aggregated)
| Directory | Responsibility Summary | Detailed Map |
| --- | --- | --- |
| `ftdetect/` | Registers filetype detection hooks for nonstandard extensions (e.g., AML) and buffer-local tweaks. | [View Map](ftdetect/codemap.md) |
| `lsp/` | Provides per-language LSP configuration tables consumed by `lspconfig`. | [View Map](lsp/codemap.md) |
| `lua/` | Core editor glue: options, keymaps, and autocmds that establish global behavior. | [View Map](lua/codemap.md) |
| `lua/plugins/` | Declares lazy.nvim plugin specs, load triggers, and configuration hooks. | [View Map](lua/plugins/codemap.md) |
| `syntax/` | Defines AML syntax highlighting groups and guard logic. | [View Map](syntax/codemap.md) |
