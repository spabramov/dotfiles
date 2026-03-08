# lua/plugins/

<!-- Explorer: Fill in this section with architectural understanding -->

## Responsibility

The `lua/plugins/` directory declares each plugin spec that lazy.nvim loads for this Neovim config. Every file returns one or more lazy.nvim tables (e.g., `lint.lua`, `conform.lua`, `dap.lua`, etc.) so that the plugin manager knows how/when to bootstrap the plugin, which events or commands trigger it, and how to wire up its configuration.

## Design Patterns

- **Lazy Spec Tables**: Each module returns plugin definitions that specify `event`, `cmd`, `keys`, `ft`, `opts`, and `config` callbacks (see `lint.lua`, `conform.lua`, `maven.lua`, `metals.lua`, etc.).
- **Event/Command Driven Loading**: Plugins load on BufRead/BufNewFile, VeryLazy, LspAttach, specific filetypes (e.g., `lazydev.lua` for Lua, `metals.lua` for Scala/Java) or commands (e.g., `Maven` in `maven.lua`).
- **Composable Config Hooks**: `config` (or `opts`) sections instantiate plugin-specific APIs, register autocommands (`lint.lua` sets up `BufEnter`/`BufWritePost` linting), and expose helpers (e.g., `dap.lua` maps function keys to dap actions, `snacks.lua` registers toggles on the `VeryLazy` event).
- **Keymap and Command Injection**: Most specs declare key bindings inline so that plugins integrate with the user’s leader mappings (`snacks.lua`, `neotest.lua`, `conform.lua`, `dap.lua`).

## Data & Control Flow

1. Lazy.nvim reads each spec when Neovim starts and watches its triggers; the designated `event`/`cmd`/`ft` fires, then lazy.nvim downloads/loads the plugin and runs its `config`/`opts`.
2. Within `config`, Lua modules `require` dependencies (`blink.lua` pulls in `mini.icons`, `dap.lua` loads `dapui`/`dap-python`, `metals.lua` builds a `bare_config`), mutates plugin state, and wires Neovim APIs (autocmds, diagnostic settings, sign definitions, etc.).
3. Keymaps and command definitions defined in the spec immediately become global after the plugin loads (`neotest.lua` defines `<leader>t*` commands, `snacks.lua` defines rich pickers and toggles, `which-key.lua` documents leader prefixes).
4. Auxiliary modules extend functionality via shared modules (e.g., `mason.lua` coordinates with `mason-lspconfig`/`mason-nvim-dap`, `dap.lua` is aware of `mason` installs, `lazydev.lua` integrates with the blink completion source).

## Integration Points

- **Core services**: Plugins configure diagnostics (`tiny-inline-diagnostics.lua` overrides `vim.diagnostic.config` before `tiny-inline-diagnostic` sets up), LSP (`lspconfig.lua` registers a `:LspCapabilities` command), formatting (`conform.lua` uses `stylua`, `ruff`, `black`), completion (`blink.lua` extends sources with `lazydev` and `mini.icons`).
- **External tooling**: `mason.lua` manages installer plugins (`mason.nvim`, `mason-lspconfig`, `mason-nvim-dap`), which other specs rely on for servers/adapters (`neotest.lua`, `dap.lua`, `metals.lua`).
- **Utility layers**: `snacks.lua` provides dashboard/picker/notification helpers that many mappings rely on; `yazi.lua`/`maven.lua` expose project-specific commands; `which-key.lua` documents leader prefixes for all custom mappings.
- **Diagnostics & Status**: `tiny-inline-diagnostics.lua`, `fidget.lua`, and `todo-comments.lua` surface runtime information within the UI, while `metals.lua` and `rustaceanvim.lua` are scoped to specific languages via `ft` settings.
