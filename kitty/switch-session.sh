#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:${PATH:-/usr/bin:/bin:/usr/sbin:/sbin}"

config_dir="${HOME}/.config/kitty"
sessions_dir="${config_dir}/sessions"
default_session="${config_dir}/default.kitty-session"
session_state="${config_dir}/session-state.json"

fzf_bin="$(command -v fzf || true)"
if [[ -z "$fzf_bin" ]]; then
  printf 'fzf not found. Install it with:\n\n  brew install fzf\n\nCurrent PATH:\n%s\n' "$PATH"
  printf '\nPress Enter to use the built-in kitty selector.'
  read -r _ || true
  kitten @ action goto_session --active-only --sort-by=alphabetical
  exit 0
fi

json_file="$(mktemp)"
entries_file="$(mktemp)"
trap 'rm -f "$json_file" "$entries_file"' EXIT

kitten @ ls > "$json_file" 2>/dev/null || printf '[]' > "$json_file"

python3 - "$json_file" "$sessions_dir" "$default_session" "$session_state" > "$entries_file" <<'PY'
import json
import sys
from pathlib import Path

json_path = Path(sys.argv[1])
sessions_dir = Path(sys.argv[2])
default_session = Path(sys.argv[3])
state_path = Path(sys.argv[4])

SESSION_EXTENSIONS = ('.session', '.kitty-session', '.kitty_session')


def load_json(path: Path, fallback):
    try:
        return json.loads(path.read_text(encoding='utf-8'))
    except Exception:
        return fallback


def session_name_from_path(path: Path) -> str:
    for suffix in SESSION_EXTENSIONS:
        if path.name.endswith(suffix):
            return path.name.removesuffix(suffix)
    return path.stem


def add_session_name(names: set[str], value) -> None:
    if value:
        names.add(str(value))


def saved_session_files() -> dict[str, str]:
    files: dict[str, str] = {}

    if sessions_dir.is_dir():
        paths = sorted(sessions_dir.iterdir(), key=lambda path: path.name.lower())
        for path in paths:
            if path.is_file() and path.name.endswith(SESSION_EXTENSIONS):
                files[session_name_from_path(path)] = str(path)

    if default_session.is_file():
        files.setdefault(session_name_from_path(default_session), str(default_session))

    return files


def state_sessions() -> tuple[str, set[str]]:
    state = load_json(state_path, {})
    if not isinstance(state, dict):
        return '', set()

    active: set[str] = set()
    for name in state.get('active') or ():
        add_session_name(active, name)

    return state.get('current') or '', active


def add_sessions_from_kitty_ls(active: set[str], current: str) -> str:
    data = load_json(json_path, [])
    if not isinstance(data, list):
        return current

    for os_window in data:
        os_focused = bool(os_window.get('is_focused') or os_window.get('last_focused'))
        for tab in os_window.get('tabs', []):
            tab_active = bool(tab.get('is_active'))
            for window in tab.get('windows', []):
                session_name = window.get('session_name') or ''
                add_session_name(active, session_name)
                if session_name and (window.get('is_focused') or (os_focused and tab_active and window.get('is_active'))):
                    current = session_name

    return current


def ordered_session_names(current: str, active: set[str], files: dict[str, str]) -> list[str]:
    seen: set[str] = set()
    ordered: list[str] = []

    for name in [current, *sorted(active, key=str.lower), *sorted(files, key=str.lower)]:
        if name and name not in seen:
            ordered.append(name)
            seen.add(name)

    return ordered


current, active = state_sessions()
current = add_sessions_from_kitty_ls(active, current)
files = saved_session_files()

for name in ordered_session_names(current, active, files):
    print(f'{name}\t{files.get(name, name)}')
PY

if [[ ! -s "$entries_file" ]]; then
  printf 'No kitty sessions found.\n\nCreate one with: ctrl+b > n\n'
  printf '\nPress Enter to exit.'
  read -r _ || true
  exit 0
fi

current="$(awk -F '\t' 'NR == 1 { print $1 }' "$entries_file")"
[[ -n "$current" ]] || current="none"

selected="$("$fzf_bin" \
  --no-sort \
  --cycle \
  --layout=reverse \
  --prompt='session> ' \
  --header="Enter: switch · Esc: cancel · ↑/↓ or j/k: move · current: ${current}" \
  --bind='j:down,k:up,ctrl-j:down,ctrl-k:up' \
  --delimiter=$'\t' \
  --with-nth=1 \
  --height=100% \
  --border < "$entries_file" || true)"

if [[ -z "$selected" ]]; then
  exit 0
fi

target="$(printf '%s' "$selected" | awk -F '\t' '{ print $2; exit }')"
if [[ -z "$target" ]]; then
  exit 0
fi

kitten @ action goto_session "$target"
