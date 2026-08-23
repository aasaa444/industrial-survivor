#!/usr/bin/env python3
"""P6 attended exported-release verification with protected native capture."""
from __future__ import annotations
import argparse, ctypes, ctypes.wintypes, hashlib, json, subprocess, sys, time, uuid
from datetime import datetime, timezone
from io import BytesIO
from pathlib import Path
from PIL import ImageGrab

sys.path.insert(0, str(Path(__file__).resolve().parent))
from candidate_identity import calculate as calculate_candidate_identity
from player_slice_capture import EnvironmentBlocked, RealInputGuard, hold_keys, tap

user32 = ctypes.windll.user32
SCHEMA = "export-window-v3"
MIN_WIDTH, MIN_HEIGHT = 800, 400


def now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def windows_for_pid(pid: int) -> list[dict]:
    found = []
    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def cb(hwnd, _):
        if not user32.IsWindowVisible(hwnd): return True
        size = user32.GetWindowTextLengthW(hwnd)
        if not size: return True
        title = ctypes.create_unicode_buffer(size + 1); user32.GetWindowTextW(hwnd, title, size + 1)
        owner = ctypes.wintypes.DWORD(); user32.GetWindowThreadProcessId(hwnd, ctypes.byref(owner))
        if owner.value == pid:
            rect = ctypes.wintypes.RECT(); user32.GetWindowRect(hwnd, ctypes.byref(rect))
            found.append({"pid": pid, "hwnd": hwnd, "title": title.value, "rect": [rect.left, rect.top, rect.right, rect.bottom], "width": rect.right - rect.left, "height": rect.bottom - rect.top})
        return True
    user32.EnumWindows(cb, 0)
    return found


def select_release_window(pid: int, expected_hwnd: int | None = None) -> dict:
    windows = windows_for_pid(pid)
    if len(windows) != 1: raise RuntimeError(f"release PID {pid} has {len(windows)} visible windows; refusing ambiguous capture")
    window = windows[0]
    if expected_hwnd is not None and int(window["hwnd"]) != expected_hwnd: raise RuntimeError("release window handle changed before capture")
    if int(window["width"]) < MIN_WIDTH or int(window["height"]) < MIN_HEIGHT: raise RuntimeError("release window is too small for evidence")
    return window


def protected_capture(game_pid: int, expected_hwnd: int, out_dir: Path, name: str, action: str, manifest: Path, transaction_id: str, candidate: dict, release_sha: str, guard: RealInputGuard) -> dict:
    guard.assert_ready()
    window = select_release_window(game_pid, expected_hwnd)
    if user32.GetForegroundWindow() != expected_hwnd: raise EnvironmentBlocked("foreground window changed before release capture", guard._environment())
    window = select_release_window(game_pid, expected_hwnd)
    if user32.GetForegroundWindow() != expected_hwnd: raise EnvironmentBlocked("release window lost foreground before capture", guard._environment())
    l, t, r, b = window["rect"]
    image = ImageGrab.grab(bbox=(l, t, r, b)).convert("RGB")
    if image.size != (window["width"], window["height"]): raise RuntimeError("release capture size mismatch")
    extrema = image.getextrema()
    if all(low == high for low, high in extrema): raise RuntimeError("release capture is flat color")
    out = out_dir / f"{name}.png"; buffer = BytesIO(); image.save(buffer, format="PNG"); out.write_bytes(buffer.getvalue())
    row = {"schema_version": SCHEMA, "capture_id": f"{transaction_id}:{name}", "transaction_id": transaction_id, "candidate_identity": candidate, "release_exe_sha256": release_sha, "pid": game_pid, "hwnd": expected_hwnd, "title": window["title"], "window_rect": window["rect"], "output": str(out.resolve()), "action": action, "captured_at_utc": now(), "image_size": list(image.size), "sha256": sha256(out), "capture_route": "protected_release_native_window", "proves": "tool-owned exported release window pixels and identity at the recorded action boundary", "does_not_prove": "authoritative runtime state, gameplay timing, QA recommendation, player enjoyment, or user acceptance"}
    out.with_suffix(out.suffix + ".json").write_text(json.dumps(row, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    with manifest.open("a", encoding="utf-8") as stream: stream.write(json.dumps(row, ensure_ascii=False) + "\n")
    return row


def diff_ratio(a: Path, b: Path) -> float:
    import numpy as np
    from PIL import Image as I
    ia = np.array(I.open(a).convert("L"), dtype=int); ib = np.array(I.open(b).convert("L"), dtype=int)
    return 100.0 if ia.shape != ib.shape else float((abs(ia - ib) > 10).mean() * 100.0)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--exe", type=Path, required=True)
    parser.add_argument("--out-dir", type=Path, required=True)
    parser.add_argument("--project-root", type=Path)
    parser.add_argument("--transaction-id")
    parser.add_argument("--candidate-identity-file", type=Path)
    parser.add_argument("--allow-real-input", action="store_true")
    args = parser.parse_args(); out = args.out_dir.resolve(); out.mkdir(parents=True, exist_ok=True)
    record = {"schema_version": "p6-release-check-v3", "steps": [], "status": "failed", "transaction_id": args.transaction_id, "real_input_authorized": args.allow_real_input, "qa_recommendation": "not_assessed", "user_acceptance": "not_requested"}
    if not args.allow_real_input:
        record.update(status="input_disabled", error="real OS input requires --allow-real-input"); (out / "interaction_record.json").write_text(json.dumps(record, indent=2) + "\n", encoding="utf-8"); print(json.dumps(record)); return 2
    if args.project_root is None or args.transaction_id is None or args.candidate_identity_file is None:
        record.update(status="blocked", error="--project-root, --transaction-id, and --candidate-identity-file are required for attended release capture"); (out / "interaction_record.json").write_text(json.dumps(record, indent=2) + "\n", encoding="utf-8"); print(json.dumps(record)); return 2
    exe = args.exe.resolve(); project = args.project_root.resolve(); candidate = json.loads(args.candidate_identity_file.read_text(encoding="utf-8"))
    if not exe.is_file() or calculate_candidate_identity(project) != candidate:
        record.update(status="blocked", error="missing release executable or candidate identity mismatch"); (out / "interaction_record.json").write_text(json.dumps(record, indent=2) + "\n", encoding="utf-8"); print(json.dumps(record)); return 2
    release_sha = sha256(exe); record["candidate_identity"] = candidate; record["release_exe_sha256"] = release_sha
    manifest = out / "manifest.jsonl"; previous_focus = user32.GetForegroundWindow(); game = subprocess.Popen([str(exe), "--qa-auto-select", "--qa-select=2"], cwd=exe.parent); window = None
    try:
        deadline = time.monotonic() + 30
        while time.monotonic() < deadline:
            candidates = windows_for_pid(game.pid)
            if len(candidates) == 1: window = candidates[0]; break
            time.sleep(.25)
        if not window: raise RuntimeError("release window did not appear")
        guard = RealInputGuard(hwnd=window["hwnd"], game_pid=game.pid, allow_real_input=True)
        user32.SetForegroundWindow(window["hwnd"]); time.sleep(.5); guard.assert_ready()
        def step(name: str, action: str):
            row = protected_capture(game.pid, window["hwnd"], out, name, action, manifest, args.transaction_id, candidate, release_sha, guard)
            record["steps"].append({"step": name, "capture": row["output"], "sha256": row["sha256"]})
        time.sleep(3); step("first_screen_3s", "clean_launch_3s")
        hold_keys(["W"], 1.2, guard); hold_keys(["D"], 1.2, guard); step("movement_feedback", "real_wasd")
        record["movement_diff_pct"] = diff_ratio(out / "first_screen_3s.png", out / "movement_feedback.png")
        time.sleep(27); step("upgrade_window_3cards", "timed_window_observation"); tap("3", guard); time.sleep(1); step("card3_selected", "real_key_3")
        time.sleep(28); step("second_window", "timed_window_observation"); tap("1", guard); time.sleep(2.5); step("rank2_combat", "real_key_1")
        tap("ESC", guard); time.sleep(.6); step("pause_overlay", "real_esc"); tap("R", guard); time.sleep(1.5); step("restart_fresh", "real_r_restart")
        record["status"] = "passed"
    except EnvironmentBlocked as error:
        record.update(status="environment_blocked", error=str(error), environment=error.environment, input_cleanup=guard.cleanup_receipts if "guard" in locals() else [])
    except Exception as error:
        record["error"] = str(error)
    finally:
        if game.poll() is None and window is not None:
            record["close_attempted"] = bool(user32.PostMessageW(window["hwnd"], 0x0010, 0, 0))
            try: game.wait(timeout=10)
            except subprocess.TimeoutExpired: record.update(status="blocked", error="tool-owned release game did not exit after WM_CLOSE; force kill disabled", unresponsive_pid=game.pid)
        if game.poll() is not None:
            record["exit_code"] = game.returncode
            if game.returncode != 0: record.update(status="blocked", error="tool_owned_release_nonzero_exit")
        if previous_focus: user32.SetForegroundWindow(previous_focus)
    (out / "interaction_record.json").write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({"status": record["status"], "qa_recommendation": record["qa_recommendation"], "user_acceptance": record["user_acceptance"], "error": record.get("error")}))
    return 0 if record["status"] == "passed" else 2


if __name__ == "__main__":
    raise SystemExit(main())
