#!/usr/bin/env bash
set -euo pipefail

sessions_dir="${HOME}/.config/kitty/sessions"
mkdir -p "$sessions_dir"

raw_name="$(kitten ask \
  --type=line \
  --name=kitty-new-session \
  --message='Имя новой kitty-сессии:' \
  --prompt='session> ' || true)"

# `kitten ask` can print a styled prompt plus a JSON object like:
#   <ansi>Имя...<ansi>{"items": [], "response": "name"}
# Extract the response field when JSON is present, otherwise use stdout as-is.
name="$(printf '%s' "$raw_name" | python3 -c '
import json
import re
import sys

raw = sys.stdin.read()
raw = re.sub(r"\x1b\[[0-9;?]*[ -/]*[@-~]", "", raw)

answer = None
for i, ch in enumerate(raw):
    if ch != "{":
        continue
    try:
        obj, _ = json.JSONDecoder().raw_decode(raw[i:])
    except Exception:
        continue
    if isinstance(obj, dict) and "response" in obj:
        answer = obj.get("response") or ""

if answer is None:
    answer = raw

print(str(answer).strip())
')"

# Trim whitespace and drop newlines/control characters.
name="$(printf '%s' "$name" | tr -d '\r\n' | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[[:cntrl:]]+//g')"

if [[ -z "$name" ]]; then
  exit 0
fi

# Keep the displayed name friendly, but make the filename safe enough for paths.
file_name="$(printf '%s' "$name" | sed -E 's#[/:]#_#g; s/^[. ]+//; s/[[:space:]]+$//')"
if [[ -z "$file_name" ]]; then
  file_name="session"
fi

session_file="${sessions_dir}/${file_name}.kitty-session"

if [[ ! -e "$session_file" ]]; then
  cwd="${PWD:-$HOME}"
  python3 - "$session_file" "$cwd" <<'PY'
from pathlib import Path
import shlex
import sys

session_file, cwd = sys.argv[1:3]
cwd = cwd.replace('\n', ' ').replace('\r', ' ').strip()

content = f"""# Auto-created by ~/.config/kitty/new-session.sh
# Save updates with: ctrl+b > Shift+s

new_tab
layout splits
enabled_layouts splits,stack
cd {shlex.quote(cwd)}
launch
focus
focus_tab 0
"""
Path(session_file).write_text(content, encoding='utf-8')
PY
fi

# Switch to the session; if it is not active yet, kitty creates it from the file.
kitten @ action goto_session "$session_file"
