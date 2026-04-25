# Keep the macOS/OS window title equal to the active kitty session name.
# kitty has no os_window_title_template option, so this watcher updates the OS
# window title and macOS menu-bar title when focus/tab state changes.

import json
from pathlib import Path
from time import time
from typing import Any

from kitty.constants import config_dir
from kitty.fast_data_types import (
    add_timer,
    current_focused_os_window_id,
    last_focused_os_window_id,
    set_os_window_title,
)

try:
    from kitty.fast_data_types import cocoa_set_menubar_title
except Exception:  # not available outside macOS builds
    cocoa_set_menubar_title = None

_last_title_by_os_window_id: dict[int, str] = {}
_session_state_file = Path(config_dir) / 'session-state.json'


def _tab_session_name(tab) -> str:
    if tab is None:
        return ''
    return getattr(tab, 'active_session_name', '') or getattr(tab, 'created_in_session_name', '') or ''


def _window_session_name(window) -> str:
    if window is None:
        return ''

    session_name = getattr(window, 'created_in_session_name', '') or _tab_session_name(window.tabref())
    if session_name:
        return session_name

    parent = getattr(window, 'overlay_parent', None)
    if parent is None:
        return ''

    return getattr(parent, 'created_in_session_name', '') or _tab_session_name(parent.tabref())


def _os_window_is_focused(os_window_id: int) -> bool:
    focused_os_window_id = current_focused_os_window_id()
    if focused_os_window_id <= 0:
        focused_os_window_id = last_focused_os_window_id()
    return focused_os_window_id == os_window_id


def _previous_current_session() -> str:
    try:
        state = json.loads(_session_state_file.read_text(encoding='utf-8'))
    except Exception:
        return ''

    if not isinstance(state, dict):
        return ''
    return state.get('current') or ''


def _write_session_state(boss) -> None:
    # The kitty author recommends boss.active_session for the current session.
    # If an overlay temporarily clears it, keep the previous value instead of
    # guessing from the overlay window.
    active_sessions = sorted(set(boss.all_loaded_session_names), key=str.lower)
    current_session = boss.active_session or _previous_current_session()

    if current_session and current_session not in active_sessions:
        active_sessions.insert(0, current_session)

    try:
        _session_state_file.write_text(json.dumps({
            'current': current_session,
            'active': active_sessions,
            'updated_at': time(),
            'boss_active_session': boss.active_session,
        }, ensure_ascii=False), encoding='utf-8')
    except Exception:
        pass


def _active_window_for_os_window(boss, os_window_id: int):
    tab_manager = boss.os_window_map.get(os_window_id)
    if tab_manager is None:
        return None
    return tab_manager.active_window or tab_manager.any_window


def _set_menubar_title(title: str) -> None:
    if cocoa_set_menubar_title is None:
        return
    try:
        cocoa_set_menubar_title(title)
    except Exception:
        pass


def _update_for_os_window(boss, os_window_id: int) -> None:
    window = _active_window_for_os_window(boss, os_window_id)
    if window is None:
        return

    session_name = boss.active_session or _window_session_name(window)
    title = session_name or window.title or 'kitty'
    _write_session_state(boss)

    if _last_title_by_os_window_id.get(os_window_id) != title:
        _last_title_by_os_window_id[os_window_id] = title
        set_os_window_title(os_window_id, title)

    if _os_window_is_focused(os_window_id):
        _set_menubar_title(title)


def _update_from_window(boss, window) -> None:
    if window is not None:
        _update_for_os_window(boss, window.os_window_id)


def _deferred_update_from_window(boss, window) -> None:
    add_timer(lambda timer_id: _update_from_window(boss, window), 0.05, False)


def on_load(boss, data: dict[str, Any]) -> None:
    for os_window_id in tuple(boss.os_window_map):
        _update_for_os_window(boss, os_window_id)


def on_focus_change(boss, window, data: dict[str, Any]) -> None:
    if data.get('focused'):
        _update_from_window(boss, window)
        _deferred_update_from_window(boss, window)


def on_tab_bar_dirty(boss, window, data: dict[str, Any]) -> None:
    tab_manager = data.get('tab_manager')
    if tab_manager is not None:
        _update_for_os_window(boss, tab_manager.os_window_id)
    else:
        _update_from_window(boss, window)


def on_title_change(boss, window, data: dict[str, Any]) -> None:
    _update_from_window(boss, window)
