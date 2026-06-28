fish_vi_key_bindings

abbr v nvim
abbr y yazi
abbr lgit lazygit
abbr ldocker lazydocker
abbr venv . .venv/bin/activate.fish
abbr drun docker run --rm -it

alias k9s "TERM=xterm-truecolor /opt/homebrew/bin/k9s"

set -U tide_left_prompt_items vi_mode pwd git newline character
set -U tide_vi_mode_icon_insert I
set -U tide_vi_mode_icon_default N
set -U tide_vi_mode_icon_replace R
set -U tide_vi_mode_icon_visual V
set -U tide_character_icon '≫⩺'
set -U tide_character_vi_icon_default '≫⩺'
set -U tide_character_vi_icon_replace '≫⩺'
set -U tide_character_vi_icon_visual '≫⩺'

set -x JAVA_HOME /opt/homebrew/opt/openjdk@17/
set -x XDG_CONFIG_HOME ~/.config/

set -x PATH "$HOME/.local/bin:$PATH"
set -x EDITOR hx
set -x VISUAL hx

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export YC_INSTALL "$HOME/yandex-cloud/"
set -gx PATH "$PATH:$BUN_INSTALL/bin:$YC_INSTALL/bin:$(go env GOPATH)/bin"

# >>> coursier install directory >>>
set -gx PATH "$PATH:/Users/sergeiabramov/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<
