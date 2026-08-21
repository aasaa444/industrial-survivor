#!/usr/bin/env python3
"""P4 defeat-path harness: real-input bad play reaches a natural defeat.

Launches the game windowed WITH --qa-auto-select (cards auto-picked so the loop is
not blocked), then holds real movement keys (SendInput) so the player runs into the
swarm — honest 'bad play' that reaches defeat through the normal contact rules,
no QA seam. Captures the result overlay, presses real R, verifies the canonical
restart, captures the fresh-run HUD.
"""
from __future__ import annotations
import argparse, ctypes, ctypes.wintypes, json, subprocess, sys, time
from pathlib import Path

GODOT = Path(r"C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe")
CAPTURE = Path(__file__).resolve().parent / "capture_game_window.py"
sys.path.insert(0, str(Path(__file__).resolve().parent))
from player_slice_capture import (INPUT, INPUT_KEYBOARD, KEYEVENTF_KEYUP, ULONG, _KEYBDINPUT,
                                  find_game_window, send_key, tap, wait_for_log_marker)

user32 = ctypes.windll.user32
VK = {"W": 0x57, "S": 0x53, "A": 0x41, "D": 0x44, "R": 0x52}


def capture(pid: int, out_dir: Path, name: str, manifest: Path) -> dict:
    out = out_dir / f"{name}.png"
    r = subprocess.run([sys.executable, str(CAPTURE), "--pid", str(pid), "--output", str(out),
                        "--project-root", str(out_dir), "--scenario", "p4_defeat", "--state", name,
                        "--action", "bad_play_defeat", "--manifest", str(manifest)],
                       capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"capture {name} failed: {r.stdout} {r.stderr}")
    return json.loads(r.stdout)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--project-root", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    ap.add_argument("--qa-select", default="0")
    a = ap.parse_args()
    project = a.project_root.resolve()
    out_dir = a.out_dir.resolve()
    out_dir.mkdir(parents=True, exist_ok=True)
    manifest = out_dir / "manifest.jsonl"
    log = out_dir / "game_stdout.log"
    prev_focus = user32.GetForegroundWindow()
    record = {"schema_version": "p4-defeat-record-v1", "status": "failed"}

    game = subprocess.Popen([str(GODOT), "--path", str(project), "--qa-auto-select", f"--qa-select={a.qa_select}"],
                            cwd=str(project), stdout=open(log, "w", encoding="utf-8", errors="replace"), stderr=subprocess.STDOUT)
    game_pid = None
    try:
        deadline = time.time() + 30
        win = None
        while time.time() < deadline and win is None:
            win = find_game_window(game.pid)
            time.sleep(0.25)
        if not win:
            raise RuntimeError("game window did not appear")
        game_pid = win["pid"]
        user32.SetForegroundWindow(win["hwnd"])
        time.sleep(0.5)

        # Bad play: keep running into the swarm (hold movement, brief pauses).
        t0 = time.time()
        while time.time() - t0 < 300:
            if "[TERMINAL] outcome=defeat" in log.read_text(encoding="utf-8", errors="replace"):
                break
            for k in ["W", "W", "D", "S", "A"]:  # weave into the swarm
                send_key(VK[k], False)
                time.sleep(0.35)
                send_key(VK[k], True)
                txt = log.read_text(encoding="utf-8", errors="replace")
                if "[TERMINAL] outcome=defeat" in txt:
                    break
        txt = log.read_text(encoding="utf-8", errors="replace")
        if "[TERMINAL] outcome=defeat" not in txt:
            raise RuntimeError("defeat not reached within 300s of bad play")
        record["defeat_reached"] = True
        time.sleep(1.0)
        row = capture(game_pid, out_dir, "defeat_result", manifest)
        record["result_capture"] = row.get("output")

        tap("R")
        rs = wait_for_log_marker(log, "TERMINAL-AUTO-RESTART] canonical reset", 10.0)
        record["restart_marker"] = rs
        time.sleep(1.5)
        row2 = capture(game_pid, out_dir, "restart_fresh_hud", manifest)
        record["restart_capture"] = row2.get("output")
        record["status"] = "passed"
    except Exception as e:
        record["error"] = str(e)
    finally:
        if game.poll() is None:
            if game_pid is not None:
                gw = find_game_window(game.pid)
                if gw:
                    user32.PostMessageW(gw["hwnd"], 0x0010, 0, 0)
            try:
                game.wait(timeout=10)
            except subprocess.TimeoutExpired:
                game.kill()
        if prev_focus:
            user32.SetForegroundWindow(prev_focus)

    (out_dir / "interaction_record.json").write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"status": record["status"], "error": record.get("error")}))
    return 0 if record["status"] == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
