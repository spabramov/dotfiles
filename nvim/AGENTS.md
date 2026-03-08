# AGENTS.md
#
# This file is for agentic coding tools working in this repo.
# It documents how to format, lint, and test changes, plus local
# style conventions observed in this configuration.

## Repo overview
- This is a Neovim configuration repository.
- Entry point: `init.lua`.
- Primary modules live in `lua/`:
- Primary modules live in `lua/`:
  - `lua/options.lua`, `lua/keymaps.lua`, `lua/autocmd.lua` for core config.
  - `lua/plugins/*` for plugin specs and configuration.
- Extra filetype hooks live in `after/`.
- Filetype-specific hooks typically live in `after/ftplugin/`.
- Formatter config: `stylua.toml`.

## Build / lint / test commands
There is no traditional build system or test suite in this repo.
Most validation happens inside Neovim via configured plugins.

### Formatting (Lua and others)
- Primary formatter: **Stylua** via **conform.nvim**.
- Config: `stylua.toml` (2-space indent, 120 column width).
- In Neovim:
  - Format current buffer: `<leader>cf` (calls `conform.format`).
  - Check formatter availability: `:ConformInfo`.
- CLI (when needed): `stylua .`

### Linting
- Linting is provided via **nvim-lint** on `BufEnter`/`BufWritePost`.
- Config: `lua/plugins/lint.lua`.
- Linters by filetype:
  - Python: `mypy`
  - JSON: `jsonlint`
  - Markdown: `markdownlint`
  - Dockerfile: `hadolint` (note: filetype key is `dokerfile` in config)
  - Rust: `clippy`
- Manual run inside Neovim (when needed):
  - `:lua require("lint").try_lint()`

### Tests (single test focus)
- There are no repo-local tests, but Neotest is configured for projects
  you edit from this Neovim instance.
- Neotest adapter: Python uses **pytest**.
- In Neovim:
  - Run nearest (single) test: `<leader>tr`.
  - Run all tests in current file: `<leader>tR`.
  - Test summary panel: `<leader>te`.
  - Show output window: `<leader>tw`.
- If you need CLI execution, run tests in the target project
  (e.g., `pytest path/to/test.py::test_name`).
- For non-Python projects, follow the target repo’s test runner
  and use Neotest if a matching adapter is configured.
- Smoke checks: `:checkhealth` can be useful after larger config changes.

## Code style guidelines
Follow existing patterns in each file. Prefer minimal, targeted changes.

### Formatting
- Run Stylua when modifying Lua files.
- `stylua.toml` sets:
  - `indent_type = "Spaces"`
  - `indent_width = 2`
  - `column_width = 120`
- Some files include modelines (e.g., `-- vim: ts=2 sts=2 sw=2 et`).
- Use `-- stylua: ignore` to preserve formatting where needed.
- Avoid manual alignment whitespace; let Stylua handle it.

### Imports / requires
- Use `require()` at the top of the file when possible.
- Assign modules to `local` variables:
  - `local lint = require("lint")`
- For optional dependencies, prefer guarded loads:
  - `local ok, mod = pcall(require, "mod")`
  - Return early if not available.
- Avoid creating globals; keep helpers `local` to the module.

### Module structure
- Keep files focused on a single concern (options, keymaps, plugin config).
- `init.lua` should only orchestrate requires.
- `lua/plugins/*` should return plugin specs, typically:
  - `return { "author/plugin", opts = { ... }, config = function() ... end }`
- Keep side effects in `config`/`init` functions, not at module top-level
  unless required (e.g., autocmd bootstrap in `treesitter.lua`).
- Prefer `opts = {}` for simple configuration and `config = function()`
  when calling plugin setup functions or adding side effects.

### Tables & layout
- Use trailing commas for multiline tables.
- Keep tables readable; align fields where it helps scanning.
- Prefer descriptive keys: `desc`, `event`, `cmd`, `opts`, `keys`.
- Use list-style tables for ordered collections; use keyed tables for configs.

### Naming conventions
- Local variables and functions: `snake_case` (e.g., `check_lsp_capabilities`).
- Use descriptive names for augroups: `vim.api.nvim_create_augroup("lsp-attach", ...)`.
- Keys should include `desc` for discoverability in keymaps.
- Augroup names should be unique and stable; avoid per-buffer names.

### Strings & quotes
- Files currently mix single and double quotes.
- Follow the local file’s existing quote style when editing that file.
- Avoid large quote-style rewrites that create noisy diffs.

### Error handling / guards
- Guard optional features with nil checks or `pcall`:
  - `if not ok then return end`
  - `if client and client_supports_method(...) then ... end`
- Check external executables before using them when practical:
  - `vim.fn.exepath(...) ~= ""`
- Use early returns to keep control flow simple.
- When accessing plugin APIs, prefer checking availability once
  and returning early to keep configuration robust.

### Diagnostics and annotations
- Use `---@diagnostic disable-next-line` only when necessary (see `options.lua`).
- Prefer explicit comments when overriding core functions (e.g., LSP utilities).
- Use EmmyLua annotations when they improve clarity:
  - `---@type`, `---@class`, `---@param`, `---@return`.

### Neovim API usage
- Use `vim.opt` for options, `vim.g` for globals.
- Use `vim.api.nvim_create_autocmd` + `vim.api.nvim_create_augroup`.
- Use `vim.keymap.set` with `{ desc = "..." }`.
- Prefer `vim.lsp.*` and `vim.diagnostic.*` for LSP interactions.
- Prefer buffer-local keymaps for LSP actions:
  - `vim.keymap.set("n", "...", ..., { buffer = bufnr, desc = "..." })`.

### Autocmds
- Always create or reuse an augroup for autocmds.
- Keep callback logic small; defer to helper functions when needed.
- Use `once = true` only for one-shot setup.

### Keymaps
- Keep `desc` short and action-oriented.
- Group related mappings together and avoid duplicate bindings.
- Prefer `silent = true` unless feedback is needed.

## Cursor / Copilot rules
- No `.cursorrules`, `.cursor/rules/`, or `.github/copilot-instructions.md`
  files were found in this repo.

## Notes for agents
- This repo is config-only; avoid introducing build scripts unless asked.
- Keep diffs small and consistent with existing style.
- When adding plugin specs, follow the patterns in `lua/plugins/*`.
- If you add new files, keep them under `lua/` or `after/` unless there is
  a clear reason to place them elsewhere.
