# Keep the macOS/OS window title equal to the active kitty session name.
#
# kitty does not currently have an os_window_title_template option. The OS
# window title normally follows the active terminal window title, while session
# names are available only on tabs/windows. This watcher updates the OS window
# title directly whenever focus/tab state changes.

from typing import Any

from kitty.fast_data_types import add_timer, current_focused_os_window_id, last_focused_os_window_id, set_os_window_title

try:
    from kitty.fast_data_types import cocoa_set_menubar_title
except Exception:  # not available outside macOS builds
    cocoa_set_menubar_title = None

_last_title_by_os_window_id: dict[int, str] = {}


def _session_name_for_window(window) -> str:
    # Prefer the actual active window session, then the tab session, then the
    # overlay parent session. The overlay-parent fallback keeps prompts/overlays
    # from temporarily blanking the application title.
    session_name = getattr(window, 'created_in_session_name', '') or ''
    tab = window.tabref() if window is not None else None
    if not session_name and tab is not None:
        session_name = getattr(tab, 'active_session_name', '') or getattr(tab, 'created_in_session_name', '') or ''
    if not session_name:
        parent = getattr(window, 'overlay_parent', None)
        if parent is not None:
            session_name = getattr(parent, 'created_in_session_name', '') or ''
            parent_tab = parent.tabref() if parent is not None else None
            if not session_name and parent_tab is not None:
                session_name = getattr(parent_tab, 'active_session_name', '') or getattr(parent_tab, 'created_in_session_name', '') or ''
    return session_name


def _os_window_is_focused(os_window_id: int) -> bool:
    focused_os_window_id = current_focused_os_window_id()
    if focused_os_window_id <= 0:
        focused_os_window_id = last_focused_os_window_id()
    return focused_os_window_id == os_window_id


def _update_for_os_window(boss, os_window_id: int) -> None:
    tab_manager = boss.os_window_map.get(os_window_id)
    if tab_manager is None:
        return

    window = tab_manager.active_window or tab_manager.any_window
    if window is None:
        return

    title = _session_name_for_window(window) or (window.title or 'kitty')

    # OS window titles are per-window; update only when the value changes.
    if _last_title_by_os_window_id.get(os_window_id) != title:
        _last_title_by_os_window_id[os_window_id] = title
        set_os_window_title(os_window_id, title)

    # On macOS kitty also maintains the application/menu-bar title separately.
    # Boss.on_focus sets it to the active terminal window title after focus
    # watchers run, so we must re-apply our session title for the focused OS
    # window even when the OS window title itself did not change.
    if cocoa_set_menubar_title is not None and _os_window_is_focused(os_window_id):
        try:
            cocoa_set_menubar_title(title)
        except Exception:
            pass


def _update_from_window(boss, window) -> None:
    if window is not None:
        _update_for_os_window(boss, window.os_window_id)


def _deferred_update_from_window(boss, window) -> None:
    # Run after kitty's own focus handler, which otherwise overwrites the macOS
    # menu-bar title with the active terminal window title.
    add_timer(lambda timer_id: _update_from_window(boss, window), 0.05, False)


def on_load(boss, data: dict[str, Any]) -> None:
    for os_window_id in tuple(boss.os_window_map):
        _update_for_os_window(boss, os_window_id)


def on_focus_change(boss, window, data: dict[str, Any]) -> None:
    # Only update on focus gain. Focus loss is followed by focus gain in another
    # window/tab and updating on both causes unnecessary churn.
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
    # If a window is not in any session, fall back to its normal title.
    _update_from_window(boss, window)
