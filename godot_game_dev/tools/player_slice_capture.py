#!/usr/bin/env python3
"""P3 player-slice capture harness: real-input E2E with L3 screenshots.

Launches the game windowed as a caller-owned process, injects REAL OS keyboard
events (SendInput; the game window is brought to foreground and focus is restored
afterwards), polls the game log for progression markers, captures verified window
screenshots at each key moment, then closes the game gracefully (WM_CLOSE).

Proves: first-screen readability moments, movement feedback, the 3-card and 1-card
upgrade windows with REAL keyboard selection through choose_upgrade, pause overlay,
and R restart. Emits an interaction record JSON + manifest rows.
"""
from __future__ import annotations
import argparse, ctypes, ctypes.wintypes, json, subprocess, sys, time
from pathlib import Path

GODOT = Path(r"C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe")
CAPTURE = Path(__file__).resolve().parent / "capture_game_window.py"

user32 = ctypes.windll.user32
VK = {"ESC": 0x1B, "1": 0x31, "2": 0x32, "3": 0x33, "R": 0x52, "W": 0x57, "A": 0x41, "S": 0x53, "D": 0x44}

INPUT_KEYBOARD = 1
KEYEVENTF_KEYUP = 0x0002

ULONG = ctypes.c_ulong

class _MOUSEINPUT(ctypes.Structure):
    _fields_ = [("dx", ctypes.c_long), ("dy", ctypes.c_long), ("mouseData", ctypes.c_ulong),
                ("dwFlags", ctypes.c_ulong), ("time", ctypes.c_ulong),
                ("dwExtraInfo", ctypes.POINTER(ULONG))]

class _KEYBDINPUT(ctypes.Structure):
    _fields_ = [("wVk", ctypes.c_ushort), ("wScan", ctypes.c_ushort), ("dwFlags", ctypes.c_ulong),
                ("time", ctypes.c_ulong), ("dwExtraInfo", ctypes.POINTER(ULONG))]

class _HARDWAREINPUT(ctypes.Structure):
    _fields_ = [("uMsg", ctypes.c_ulong), ("wParamL", ctypes.c_ushort), ("wParamH", ctypes.c_ushort)]

class _INPUT_UNION(ctypes.Union):
    _fields_ = [("mi", _MOUSEINPUT), ("ki", _KEYBDINPUT), ("hi", _HARDWAREINPUT)]

class INPUT(ctypes.Structure):
    _anonymous_ = ("u",)
    _fields_ = [("type", ULONG), ("u", _INPUT_UNION)]

def send_key(vk: int, up: bool) -> None:
    inp = INPUT(type=INPUT_KEYBOARD)
    inp.ki = _KEYBDINPUT(vk, 0, KEYEVENTF_KEYUP if up else 0, 0, None)
    n = user32.SendInput(1, ctypes.byref(inp), ctypes.sizeof(INPUT))
    if n != 1:
        raise RuntimeError(f"SendInput failed for vk={vk:#x} (expected sizeof(INPUT)={ctypes.sizeof(INPUT)})")

def tap(key: str, hold: float = 0.08) -> None:
    send_key(VK[key], False)
    time.sleep(hold)
    send_key(VK[key], True)

def hold_keys(keys: list[str], seconds: float) -> None:
    for k in keys:
        send_key(VK[k], False)
    time.sleep(seconds)
    for k in keys:
        send_key(VK[k], True)

def child_game_pid(console_pid: int, timeout: float = 20.0) -> int:
    """The console wrapper spawns the real game process; resolve its PID via the
    toolhelp snapshot (parent == console_pid)."""
    TH32CS_SNAPPROCESS = 0x00000002
    class PROCESSENTRY32W(ctypes.Structure):
        _fields_ = [("dwSize", ctypes.c_ulong), ("cntUsage", ctypes.c_ulong), ("th32ProcessID", ctypes.c_ulong),
                    ("th32DefaultHeapID", ctypes.POINTER(ctypes.c_ulong)), ("th32ModuleID", ctypes.c_ulong),
                    ("cntThreads", ctypes.c_ulong), ("th32ParentProcessID", ctypes.c_ulong),
                    ("pcPriClassBase", ctypes.c_long), ("dwFlags", ctypes.c_ulong), ("szExeFile", ctypes.c_wchar * 260)]
    deadline = time.time() + timeout
    while time.time() < deadline:
        snap = ctypes.windll.kernel32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
        if snap == -1:
            raise RuntimeError("CreateToolhelp32Snapshot failed")
        try:
            e = PROCESSENTRY32W(); e.dwSize = ctypes.sizeof(PROCESSENTRY32W)
            ok = ctypes.windll.kernel32.Process32FirstW(snap, ctypes.byref(e))
            while ok:
                if e.th32ParentProcessID == console_pid and e.szExeFile.lower().startswith("godot"):
                    return e.th32ProcessID
                ok = ctypes.windll.kernel32.Process32NextW(snap, ctypes.byref(e))
        finally:
            ctypes.windll.kernel32.CloseHandle(snap)
        time.sleep(0.25)
    raise RuntimeError("child game process did not appear")

def parent_of_pid(pid: int) -> int:
    TH32CS_SNAPPROCESS = 0x00000002
    class PROCESSENTRY32W(ctypes.Structure):
        _fields_ = [("dwSize", ctypes.c_ulong), ("cntUsage", ctypes.c_ulong), ("th32ProcessID", ctypes.c_ulong),
                    ("th32DefaultHeapID", ctypes.POINTER(ctypes.c_ulong)), ("th32ModuleID", ctypes.c_ulong),
                    ("cntThreads", ctypes.c_ulong), ("th32ParentProcessID", ctypes.c_ulong),
                    ("pcPriClassBase", ctypes.c_long), ("dwFlags", ctypes.c_ulong), ("szExeFile", ctypes.c_wchar * 260)]
    snap = ctypes.windll.kernel32.CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    if snap == -1:
        return -1
    try:
        e = PROCESSENTRY32W(); e.dwSize = ctypes.sizeof(PROCESSENTRY32W)
        ok = ctypes.windll.kernel32.Process32FirstW(snap, ctypes.byref(e))
        while ok:
            if e.th32ProcessID == pid:
                return e.th32ParentProcessID
            ok = ctypes.windll.kernel32.Process32NextW(snap, ctypes.byref(e))
    finally:
        ctypes.windll.kernel32.CloseHandle(snap)
    return -1

def find_game_window(console_pid: int):
    """Resolve the game window by TITLE marker plus process parentage: the window's
    owning process must be a direct child of our console wrapper. This never matches
    the user's editor or an editor-launched game."""
    result = None
    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def cb(hwnd, _):
        nonlocal result
        if not user32.IsWindowVisible(hwnd):
            return True
        n = user32.GetWindowTextLengthW(hwnd)
        if n == 0:
            return True
        b = ctypes.create_unicode_buffer(n + 2)
        user32.GetWindowTextW(hwnd, b, n + 1)
        if "(debug)" not in b.value.lower():
            return True
        pid = ctypes.wintypes.DWORD()
        user32.GetWindowThreadProcessId(hwnd, ctypes.byref(pid))
        if pid.value and parent_of_pid(pid.value) == console_pid:
            r = ctypes.wintypes.RECT()
            user32.GetWindowRect(hwnd, ctypes.byref(r))
            result = {"pid": pid.value, "hwnd": hwnd, "title": b.value, "rect": [r.left, r.top, r.right, r.bottom]}
        return True
    user32.EnumWindows(cb, 0)
    return result

def game_window(pid: int):
    best = None
    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def cb(hwnd, _):
        nonlocal best
        if not user32.IsWindowVisible(hwnd):
            return True
        n = user32.GetWindowTextLengthW(hwnd)
        b = ctypes.create_unicode_buffer(n + 1)
        user32.GetWindowTextW(hwnd, b, n)
        title = b.value
        p = ctypes.wintypes.DWORD()
        user32.GetWindowThreadProcessId(hwnd, ctypes.byref(p))
        if p.value == pid and "(debug)" in title.lower():
            best = (hwnd, title)
        return True
    user32.EnumWindows(cb, 0)
    return best

def wait_for_window(console_pid: int, timeout: float = 25.0):
    deadline = time.time() + timeout
    while time.time() < deadline:
        w = find_game_window(console_pid)
        if w:
            return w
        time.sleep(0.25)
    raise RuntimeError("game window did not appear")

def wait_for_log_marker(log: Path, marker: str, timeout: float) -> str:
    deadline = time.time() + timeout
    while time.time() < deadline:
        if log.exists():
            text = log.read_text(encoding="utf-8", errors="replace")
            idx = text.rfind(marker)
            if idx >= 0:
                line_end = text.find("\n", idx)
                return text[idx:line_end if line_end > 0 else len(text)].strip()
        time.sleep(0.2)
    raise RuntimeError(f"timeout waiting for log marker: {marker}")

def capture(pid: int, out_dir: Path, name: str, scenario: str, state: str, action: str, manifest: Path) -> dict:
    out = out_dir / f"{name}.png"
    r = subprocess.run([sys.executable, str(CAPTURE), "--pid", str(pid), "--output", str(out),
                        "--project-root", str(out_dir), "--scenario", scenario, "--state", state,
                        "--action", action, "--manifest", str(manifest)],
                       capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"capture {name} failed: {r.stdout} {r.stderr}")
    return json.loads(r.stdout)

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--project-root", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    a = ap.parse_args()
    project = a.project_root.resolve()
    out_dir = a.out_dir.resolve()
    out_dir.mkdir(parents=True, exist_ok=True)
    manifest = out_dir / "manifest.jsonl"
    log = out_dir / "game_stdout.log"
    prev_focus = user32.GetForegroundWindow()
    record = {"schema_version": "p3-slice-record-v1", "steps": [], "status": "failed"}
    game_pid = None

    game = subprocess.Popen([str(GODOT), "--path", str(project)], cwd=str(project),
                            stdout=open(log, "w", encoding="utf-8", errors="replace"),
                            stderr=subprocess.STDOUT)
    try:
        win = wait_for_window(game.pid)
        game_pid = win["pid"]
        hwnd = win["hwnd"]
        title = win["title"]
        user32.SetForegroundWindow(hwnd)
        time.sleep(0.5)

        def step(name: str, desc: str, **kw):
            row = capture(game_pid, out_dir, name, "p3_slice", kw.get("state", name), kw.get("action", desc), manifest)
            record["steps"].append({"step": name, "desc": desc, "capture": row.get("output"), "sha256": row.get("sha256")})
            print(f"[P3] {name}: {row.get('output')}")

        time.sleep(3.0)
        step("first_screen_3s", "first screen readability at 3s", state="clean_launch_3s", action="idle")
        hold_keys(["W"], 1.2)
        hold_keys(["D"], 1.2)
        step("movement_feedback", "world scroll after real WASD holds", state="after_movement", action="real_wasd")

        m = wait_for_log_marker(log, "window opened phase=build_choice", 90.0)
        record["steps"].append({"step": "build_choice_open", "log": m})
        time.sleep(1.0)
        step("build_choice_3cards", "3-card build choice window", state="build_choice_inspection", action="await_real_key")

        tap("2")
        sel = wait_for_log_marker(log, "card selected idx=1 phase=build_choice source=keyboard", 10.0)
        record["steps"].append({"step": "real_keyboard_select_2", "log": sel})
        time.sleep(0.3)
        step("build_choice_selected", "selection feedback (pressed/acquired)", state="card_pressed", action="real_key_2")
        wait_for_log_marker(log, "window closed; combat resumed", 10.0)
        time.sleep(1.0)
        step("combat_with_fan", "combat with fan build active", state="fan_rank1_combat", action="auto_attack")

        m2 = wait_for_log_marker(log, "window opened phase=build_upgrade", 120.0)
        record["steps"].append({"step": "build_upgrade_open", "log": m2})
        time.sleep(1.0)
        step("build_upgrade_1card", "single-card rank upgrade window", state="build_upgrade_inspection", action="await_real_key")
        tap("1")
        sel2 = wait_for_log_marker(log, "card selected idx=0 phase=build_upgrade source=keyboard", 10.0)
        record["steps"].append({"step": "real_keyboard_select_1", "log": sel2})
        wait_for_log_marker(log, "window closed; combat resumed", 10.0)
        time.sleep(1.0)
        step("rank2_combat", "combat after rank 2 upgrade", state="fan_rank2_combat", action="auto_attack")

        # Rank-3 (and any later) windows can open at any moment; dismiss whatever is
        # pending BEFORE the pause check so ESC/R are not swallowed by the window guard.
        while True:
            text = log.read_text(encoding="utf-8", errors="replace")
            opened = text.count("window opened phase=")
            closed = text.count("window closed; combat resumed")
            if opened <= closed:
                break
            time.sleep(1.0)
            tap("1")
            try:
                wait_for_log_marker(log, "window closed; combat resumed", 10.0)
            except RuntimeError:
                break

        tap("ESC")
        time.sleep(0.6)
        step("pause_overlay", "ESC pause overlay", state="paused", action="real_esc")
        tap("R")
        rs = wait_for_log_marker(log, "TERMINAL-AUTO-RESTART] canonical reset", 10.0)
        record["steps"].append({"step": "real_r_restart", "log": rs})
        time.sleep(1.5)
        step("restarted_clean", "fresh run after R restart", state="fresh_run", action="post_restart")

        record["status"] = "passed"
        record["game_pid"] = game.pid
        record["window_title"] = title
    except Exception as e:
        record["error"] = str(e)
    finally:
        if game.poll() is None:
            if game_pid is not None:
                gw = game_window(game_pid)
                if gw:
                    user32.PostMessageW(gw[0], 0x0010, 0, 0)  # WM_CLOSE graceful
            try:
                game.wait(timeout=10)
            except subprocess.TimeoutExpired:
                game.kill()
        if prev_focus:
            user32.SetForegroundWindow(prev_focus)

    (out_dir / "interaction_record.json").write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"status": record["status"], "steps": len(record["steps"]), "error": record.get("error")}))
    return 0 if record["status"] == "passed" else 1

if __name__ == "__main__":
    raise SystemExit(main())
