# ftdetect/

<!-- Explorer: Fill in this section with architectural understanding -->

## Responsibility

The `ftdetect/` directory registers filetype detection hooks for nonstandard or project-specific file extensions. It ensures that files such as `*.aml` are recognized by Neovim early in the buffer creation lifecycle so that appropriate syntax, indentation, and other filetype-dependent behaviors can be applied.

## Design Patterns

- **Autocommand-driven detection**: Each script uses `au BufRead,BufNewFile` commands scoped to a glob, which is the canonical way Neovim lazily maps file extensions to filetypes without polling or manual intervention.
- **FileType autocmds for local tweaks**: Immediately after setting the filetype, a `FileType` auto command enforces buffer-local settings (e.g., `commentstring`, `nosspell`, `nowrap`), keeping language-specific adjustments encapsulated close to the detection logic.

## Data & Control Flow

Loading occurs when Neovim starts and sources `ftdetect/*.vim`. For every buffer that matches `*.aml`, Neovim runs the defined `BufRead`/`BufNewFile` event, sets the `aml` filetype, and triggers any `FileType` autocmds. Those `FileType` hooks then configure buffer-local options: comment string, spelling, and wrapping. No other scripts modify this flow.

## Integration Points

- Relies on Neovim's autocmd system (`BufRead`, `BufNewFile`, `FileType`) to integrate with the runtime detection lifecycle.
- The `aml` filetype name feeds into other plugin/configuration modules (e.g., files under `after/ftplugin`, `syntax/`, or `lua/config`) that may define syntax or behavior for `aml`. This module simply declares the filetype so those downstream plugins can activate.
