# syntax/

## Responsibility

- Provide AML-specific syntax highlighting definitions within the user-wide Neovim setup under `syntax/`.
- Guard rerunning via `b:current_syntax` to avoid duplicate definitions when the file is reloaded.

## Design Patterns (if any)

- Declarative Vim syntax rules (`syn match`, `syn region`) for TODOs, attributes, elements, components, strings, and variable-like regions.
- Link custom groups to base highlight groups (`hi def link ...`) to reuse Neovim’s color settings.

## Data & Control Flow

- On sourcing, the script first checks `b:current_syntax` and early exits if already set, then defines syntax matches/regions sequentially.
- Definitions describe attribute blocks (`[ ... ]`), metadata (`key:`/`: value`), component labels (`@name`), plain elements, strings, comments, and TODO markers, establishing the text-to-group mapping Neovim uses for highlighting.
- After defining groups, it sets `b:current_syntax = "aml"` to signal completion.

## Integration Points

- Loaded automatically when an AML filetype triggers Neovim’s syntax detection (typically via `ftplugin` linkage or `:set syntax=aml`).
- Relies on global highlight groups like `Statement`, `Identifier`, `Constant`, etc., so it integrates with the user’s colorscheme without redefining colors.
