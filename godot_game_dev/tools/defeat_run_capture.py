#!/usr/bin/env python3
"""P4 defeat-path harness: real-input bad play reaches a natural defeat.

Launches the game windowed WITH --qa-auto-select (cards auto-picked so the loop is
not blocked), then holds real movement keys (SendInput) so the player runs into the
swarm — honest 'bad play' that reaches defeat through the normal contact rules,
no QA seam. Captures the result overlay, presses real R, verifies the canonical
restart, captures the fresh-run HUD.
"""
from __future__ import annotations
import argparse, ctypes, ctypes.wintypes, json, subprocess, sys, time, uuid
from pathlib import Path

GODOT = Path(r"C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe")
CAPTURE = Path(__file__).resolve().parent / "capture_game_window.py"
sys.path.insert(0, str(Path(__file__).resolve().parent))
from player_slice_capture import (EnvironmentBlocked, INPUT, INPUT_KEYBOARD, KEYEVENTF_KEYUP, ULONG, _KEYBDINPUT,
                                  RealInputGuard, find_game_window, parent_of_pid, send_key, tap, wait_for_log_marker)
from candidate_identity import calculate as calculate_candidate_identity

user32 = ctypes.windll.user32
VK = {"W": 0x57, "S": 0x53, "A": 0x41, "D": 0x44, "R": 0x52}


def capture(pid: int, out_dir: Path, name: str, manifest: Path, transaction_id: str, candidate_file: Path) -> dict:
    out = out_dir / f"{name}.png"
    r = subprocess.run([sys.executable, str(CAPTURE), "--pid", str(pid), "--output", str(out),
                        "--project-root", str(out_dir), "--scenario", "p4_defeat", "--state", name,
                        "--action", "bad_play_defeat", "--manifest", str(manifest), "--no-focus-steal",
                        "--transaction-id", transaction_id, "--candidate-identity-file", str(candidate_file)],
                       capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"capture {name} failed: {r.stdout} {r.stderr}")
    return json.loads(r.stdout)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--project-root", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    ap.add_argument("--qa-select", default="0")
    ap.add_argument("--allow-real-input", action="store_true", help="Explicitly allow foreground-bound SendInput for this attended run.")
    a = ap.parse_args()
    project = a.project_root.resolve()
    out_dir = a.out_dir.resolve()
    out_dir.mkdir(parents=True, exist_ok=True)
    manifest = out_dir / "manifest.jsonl"
    log = out_dir / "game_stdout.log"
    prev_focus = user32.GetForegroundWindow()
    record = {"schema_version": "p4-defeat-record-v3", "status": "failed", "real_input_authorized": a.allow_real_input}
    if not a.allow_real_input:
        record.update(status="input_disabled", error="real OS input requires --allow-real-input")
        (out_dir / "interaction_record.json").write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding="utf-8")
        print(json.dumps({"status": record["status"], "error": record["error"]}))
        return 2
    candidate = calculate_candidate_identity(project)
    candidate_file = out_dir / "candidate_identity.json"
    candidate_file.write_text(json.dumps(candidate, ensure_ascii=False, indent=2), encoding="utf-8")
    transaction_id = f"TX-P4-{uuid.uuid4().hex[:12]}"
    record.update(transaction_id=transaction_id, candidate_identity=candidate)

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
        guard = RealInputGuard(hwnd=win["hwnd"], game_pid=game_pid, console_pid=game.pid, allow_real_input=a.allow_real_input, parent_lookup=parent_of_pid)
        user32.SetForegroundWindow(win["hwnd"])
        time.sleep(0.5)
        guard.assert_ready()

        # Bad play: keep running into the swarm (hold movement, brief pauses).
        t0 = time.time()
        while time.time() - t0 < 300:
            if "[TERMINAL] outcome=defeat" in log.read_text(encoding="utf-8", errors="replace"):
                break
            for k in ["W", "W", "D", "S", "A"]:  # weave into the swarm
                tap(k, guard, hold=0.35)
                txt = log.read_text(encoding="utf-8", errors="replace")
                if "[TERMINAL] outcome=defeat" in txt:
                    break
        txt = log.read_text(encoding="utf-8", errors="replace")
        if "[TERMINAL] outcome=defeat" not in txt:
            raise RuntimeError("defeat not reached within 300s of bad play")
        record["defeat_reached"] = True
        time.sleep(1.0)
        row = capture(game_pid, out_dir, "defeat_result", manifest, transaction_id, candidate_file)
        record["result_capture"] = row.get("output")

        tap("R", guard)
        rs = wait_for_log_marker(log, "TERMINAL-AUTO-RESTART] canonical reset", 10.0)
        record["restart_marker"] = rs
        time.sleep(1.5)
        row2 = capture(game_pid, out_dir, "restart_fresh_hud", manifest, transaction_id, candidate_file)
        record["restart_capture"] = row2.get("output")
        record["status"] = "passed"
    except EnvironmentBlocked as error:
        record.update(status="environment_blocked", error=str(error), environment=error.environment, input_cleanup=guard.cleanup_receipts)
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
                record.update(status="blocked", error="tool-owned game did not exit after WM_CLOSE; force kill disabled", unresponsive_pid=game.pid)
        if prev_focus:
            user32.SetForegroundWindow(prev_focus)

    (out_dir / "interaction_record.json").write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"status": record["status"], "error": record.get("error")}))
    return 0 if record["status"] == "passed" else 2


if __name__ == "__main__":
    raise SystemExit(main())
