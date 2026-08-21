#!/usr/bin/env python3
"""P6 exported-release verification: real-input slice inside the export package.

Launches the exported RELEASE exe (no editor, no dev paths), drives the loop with
real OS keyboard input, and captures window-identity-verified screenshots at the
key moments. The release build has no console output, so all evidence is
timing + screenshot based; the debug export provides the log-based six-minute
evidence separately.
"""
from __future__ import annotations
import argparse, ctypes, ctypes.wintypes, hashlib, json, subprocess, sys, time
from datetime import datetime, timezone
from pathlib import Path
from PIL import ImageGrab

sys.path.insert(0, str(Path(__file__).resolve().parent))
from player_slice_capture import send_key, tap, hold_keys

user32 = ctypes.windll.user32
SCHEMA = "export-window-v1"


def find_window_by_pid(pid: int):
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
        p = ctypes.wintypes.DWORD()
        user32.GetWindowThreadProcessId(hwnd, ctypes.byref(p))
        if p.value == pid:
            r = ctypes.wintypes.RECT()
            user32.GetWindowRect(hwnd, ctypes.byref(r))
            result = {"hwnd": hwnd, "title": b.value, "rect": [r.left, r.top, r.right, r.bottom]}
        return True
    user32.EnumWindows(cb, 0)
    return result


def wait_window(pid: int, timeout: float = 30.0):
    deadline = time.time() + timeout
    while time.time() < deadline:
        w = find_window_by_pid(pid)
        if w:
            return w
        time.sleep(0.25)
    raise RuntimeError("export window did not appear")


def capture(win: dict, out: Path, name: str, action: str, manifest: Path, sha: str) -> dict:
    img = ImageGrab.grab(bbox=tuple(win["rect"]), all_screens=True)
    out_file = out / f"{name}.png"
    img.save(out_file)
    digest = hashlib.sha256(out_file.read_bytes()).hexdigest()
    row = {"schema_version": SCHEMA, "title": win["title"], "window_rect": win["rect"],
           "output": str(out_file.resolve()), "action": action, "git_sha": sha,
           "captured_at_utc": datetime.now(timezone.utc).isoformat(),
           "image_size": list(img.size), "sha256": digest,
           "evidence_boundary": "exported release window pixels; identity by pid+rect+title"}
    with open(manifest, "a", encoding="utf-8") as f:
        f.write(json.dumps(row, ensure_ascii=False) + "\n")
    return row


def diff_ratio(a: Path, b: Path) -> float:
    import numpy as np
    from PIL import Image as I
    ia = np.array(I.open(a).convert("L"), dtype=int)
    ib = np.array(I.open(b).convert("L"), dtype=int)
    if ia.shape != ib.shape:
        return 100.0
    return float((np.abs(ia - ib) > 10).mean() * 100.0)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--exe", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    ap.add_argument("--sha", default="")
    a = ap.parse_args()
    out_dir = a.out_dir.resolve()
    out_dir.mkdir(parents=True, exist_ok=True)
    manifest = out_dir / "manifest.jsonl"
    record = {"schema_version": "p6-release-check-v1", "steps": [], "status": "failed"}
    prev_focus = user32.GetForegroundWindow()
    game = subprocess.Popen([str(a.exe.resolve()), "--qa-auto-select", "--qa-select=2"],
                            cwd=str(a.exe.resolve().parent))
    win = None
    try:
        win = wait_window(game.pid)
        user32.SetForegroundWindow(win["hwnd"])
        time.sleep(0.5)

        def step(name: str, action: str):
            row = capture(win, out_dir, name, action, manifest, a.sha)
            record["steps"].append({"step": name, "capture": row["output"], "sha256": row["sha256"]})
            print(f"[P6] {name}")

        time.sleep(3.0)
        step("first_screen_3s", "clean_launch_3s")
        hold_keys(["W"], 1.2)
        hold_keys(["D"], 1.2)
        step("movement_feedback", "real_wasd")
        record["movement_diff_pct"] = diff_ratio(out_dir / "first_screen_3s.png", out_dir / "movement_feedback.png")

        # Pacing-verified window timing (31s/58s/101s curve): first window ~31-35s.
        time.sleep(27.0)
        step("upgrade_window_3cards", "await_real_key")
        tap("3")
        time.sleep(1.0)
        step("card3_selected", "real_key_3_pulse")
        time.sleep(28.0)
        step("second_window", "await_real_key")
        tap("1")
        time.sleep(2.5)
        step("rank2_combat", "real_key_1_rankup")
        tap("ESC")
        time.sleep(0.6)
        step("pause_overlay", "real_esc")
        tap("R")
        time.sleep(1.5)
        step("restart_fresh", "real_r_restart")
        record["status"] = "passed"
    except Exception as e:
        record["error"] = str(e)
    finally:
        if game.poll() is None:
            if win:
                user32.PostMessageW(win["hwnd"], 0x0010, 0, 0)
            try:
                game.wait(timeout=10)
            except subprocess.TimeoutExpired:
                game.kill()
        if prev_focus:
            user32.SetForegroundWindow(prev_focus)

    (out_dir / "interaction_record.json").write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"status": record["status"], "movement_diff_pct": record.get("movement_diff_pct"), "error": record.get("error")}))
    return 0 if record["status"] == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
