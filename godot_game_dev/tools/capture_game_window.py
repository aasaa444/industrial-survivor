#!/usr/bin/env python3
"""Capture one verified Godot DEBUG window by explicit PID.

This is an isolated native-window diagnostic tool. It proves visible window pixels and
window identity, not runtime gameplay/domain correctness. It refuses editor, ambiguous,
small, wrong-title, size-mismatched, and flat-color captures.
"""
from __future__ import annotations
import argparse, ctypes, ctypes.wintypes, hashlib, json, os, platform, subprocess, sys, time
from datetime import datetime, timezone
from io import BytesIO
from pathlib import Path
from PIL import ImageGrab, __version__ as PILLOW_VERSION

MIN_WIDTH, MIN_HEIGHT = 800, 400
EDITOR_TITLE_MARKERS = ("godot engine", "main.tscn -")
GAME_TITLE_MARKER = "(debug)"
SCHEMA_VERSION = "capture-window-v1"
user32 = ctypes.windll.user32


def window_title(hwnd: int) -> str:
    n = user32.GetWindowTextLengthW(hwnd); b = ctypes.create_unicode_buffer(n + 1)
    user32.GetWindowTextW(hwnd, b, n + 1); return b.value


def window_pid(hwnd: int) -> int:
    pid = ctypes.wintypes.DWORD(); user32.GetWindowThreadProcessId(hwnd, ctypes.byref(pid)); return pid.value


def window_rect(hwnd: int) -> tuple[int, int, int, int]:
    r = ctypes.wintypes.RECT(); user32.GetWindowRect(hwnd, ctypes.byref(r)); return r.left, r.top, r.right, r.bottom


def windows() -> list[dict[str, object]]:
    found: list[dict[str, object]] = []
    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def callback(hwnd: int, _: int) -> bool:
        if not user32.IsWindowVisible(hwnd): return True
        title = window_title(hwnd)
        if not title: return True
        l, t, r, b = window_rect(hwnd)
        found.append({"hwnd": hwnd, "pid": window_pid(hwnd), "title": title, "rect": [l, t, r, b], "width": r-l, "height": b-t})
        return True
    user32.EnumWindows(callback, 0); return found


def select_game_window(pid: int) -> dict[str, object]:
    candidates = [w for w in windows() if w["pid"] == pid]
    if not candidates: raise RuntimeError(f"No visible top-level window for PID {pid}.")
    if len(candidates) != 1: raise RuntimeError(f"PID {pid} has {len(candidates)} visible windows; refusing ambiguous capture.")
    w = candidates[0]; title = str(w["title"]); lower = title.lower()
    if any(marker in lower for marker in EDITOR_TITLE_MARKERS): raise RuntimeError(f"Refusing editor window title: {title!r}")
    if GAME_TITLE_MARKER not in lower: raise RuntimeError(f"Refusing non-DEBUG game window title: {title!r}")
    if int(w["width"]) < MIN_WIDTH or int(w["height"]) < MIN_HEIGHT:
        raise RuntimeError(f"Refusing small window {w['width']}x{w['height']}; expected at least {MIN_WIDTH}x{MIN_HEIGHT}.")
    return w


def git_sha(cwd: Path) -> str:
    try: return subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=cwd, text=True, stderr=subprocess.DEVNULL).strip()
    except Exception: return "unknown"


def main() -> int:
    p = argparse.ArgumentParser(description="Capture verified Godot DEBUG window by PID.")
    p.add_argument("--pid", type=int, required=True)
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--project-root", type=Path, default=Path.cwd())
    p.add_argument("--scenario", default="unspecified")
    p.add_argument("--state", default="unspecified")
    p.add_argument("--action", default="unspecified")
    p.add_argument("--wait", type=float, default=0.0)
    p.add_argument("--dry-run", action="store_true")
    p.add_argument("--manifest", type=Path, help="JSONL manifest appended on success")
    a = p.parse_args(); root = a.project_root.resolve(); w = select_game_window(a.pid)
    plan = {"schema_version": SCHEMA_VERSION, "pid": a.pid, "title": w["title"], "window_rect": w["rect"], "project_root": str(root), "output": str(a.output.resolve()), "scenario": a.scenario, "state": a.state, "action": a.action, "git_sha": git_sha(root), "will_mutate_project": False}
    if a.dry_run:
        print(json.dumps(plan, ensure_ascii=False)); return 0
    if a.wait > 0: time.sleep(a.wait); w = select_game_window(a.pid)
    hwnd = int(w["hwnd"])
    user32.SetForegroundWindow(hwnd)
    user32.BringWindowToTop(hwnd)
    time.sleep(.15)
    # Desktop capture sees whatever is visibly on top of the rectangle. Refuse if
    # the requested game is not foreground at the instant of capture; never risk
    # recording a chat/private app layered over the game (2026-08-21 incident).
    if user32.GetForegroundWindow() != hwnd:
        user32.SetForegroundWindow(hwnd)
        user32.BringWindowToTop(hwnd)
        time.sleep(.25)
        if user32.GetForegroundWindow() != hwnd:
            raise RuntimeError("Target game window is not foreground; refusing capture to protect unrelated application content.")
    # Re-enumerate immediately before capture: title/PID/rect must still describe
    # the same unique game window, not a stale or replaced handle.
    w = select_game_window(a.pid)
    if int(w["hwnd"]) != hwnd:
        raise RuntimeError("Target window handle changed before capture; refusing stale-window capture.")
    l, t, r, b = [int(v) for v in w["rect"]]
    image = ImageGrab.grab(bbox=(l, t, r, b)).convert("RGB")
    if image.size != (int(w["width"]), int(w["height"])): raise RuntimeError("Capture size does not match target window size.")
    average = image.resize((1, 1)).getpixel((0, 0)); extrema = image.getextrema()
    if all(lo == hi for lo, hi in extrema): raise RuntimeError(f"Capture is single flat color {average}; refusing evidence.")
    a.output.parent.mkdir(parents=True, exist_ok=True); buf = BytesIO(); image.save(buf, format="PNG"); data = buf.getvalue(); a.output.write_bytes(data)
    meta = {**plan, "captured_at_utc": datetime.now(timezone.utc).isoformat(), "image_size": list(image.size), "average_rgb": list(average), "sha256": hashlib.sha256(data).hexdigest(), "capture_route": "native_window_diagnostic", "platform": platform.platform(), "python": sys.version.split()[0], "pillow": PILLOW_VERSION, "evidence_boundary": "visible pixels/window identity only; runtime domain state unproven"}
    sidecar = a.output.with_suffix(a.output.suffix + ".json"); sidecar.write_text(json.dumps(meta, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    if a.manifest:
        a.manifest.parent.mkdir(parents=True, exist_ok=True)
        with a.manifest.open("a", encoding="utf-8") as f: f.write(json.dumps(meta, ensure_ascii=False)+"\n")
    print(json.dumps(meta, ensure_ascii=False)); return 0

if __name__ == "__main__":
    try: raise SystemExit(main())
    except RuntimeError as e: print(f"capture rejected: {e}", file=sys.stderr); raise SystemExit(2)
