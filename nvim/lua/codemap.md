# lua/

## Responsibility
- Hosts the core Neovim front‑end glue: editor-wide settings, repeated keymaps, and lightweight autocommands that are independent of plugin specs.
- Provides the foundation that lazy-loaded plugins inherit (leader keys, floating borders, user-defined filetype mapping, clipboard behavior, etc.).

## Design Patterns
- Declarative configuration: each file batch-sets `vim.opt`, `vim.g`, or `vim.keymap.set` with plain tables instead of imperative logic to keep the state predictable and easy to audit.
- Event-driven hooks: `autocmd.lua` defines self-contained callbacks for yank highlighting, restore cursor position, and LSP lifecycle hooks, leveraging Neovim’s autocmd groups for scoped side effects.
- Wrapper utilities: `options.lua` monkey-patches `vim.lsp.util.open_floating_preview` so every module using LSP floats shares consistent styling without duplicating border setup.

## Data & Control Flow
- `options.lua` runs at startup (via `init.lua`) before plugin loading, setting global leaders, default font flags, filetype overrides, display/behavioral opts, and provider toggles. These globals propagate outward because plugins read `vim.g`, while `vim.opt` changes immediately mutate the Neovim state machine.
- `keymaps.lua` registers application-wide normal/terminal mappings the moment it loads; it only references existing Vim functions/commands, so control flow is strictly input → mapped action → Vim API call.
- `autocmd.lua` installs autocmds that Neovim triggers asynchronously (TextYankPost, BufReadPost, LspAttach). Each callback inspects runtime state (marks, buffer counts, LSP client capabilities) and enlists further autocmds or keymaps, so the flow is: event → callback → API operations (highlight, cursor jump, LSP keymap setup, highlight cleanup).

## Integration Points
- `init.lua` (root of config) loads these modules before/alongside plugin specs, so their settings and automations are available globally; they have no direct plugin dependencies but influence plugin behavior through shared globals (`vim.g.mapleader`, filetype assignments, floating preview overrides).
- `autocmd.lua` hooks into Neovim’s LSP lifecycle and diagnostic APIs, enabling features (floating diagnostics, signature help, document highlighting) that plugins (like `nvim-lspconfig`) expect to be wired up when clients attach.
- `keymaps.lua` provides user-facing bindings for window navigation, diagnostics, and motion, so any plugin that adds commands or diagnostics will automatically benefit from the existing mappings (e.g., diagnostic floats, quickfix list entries).
