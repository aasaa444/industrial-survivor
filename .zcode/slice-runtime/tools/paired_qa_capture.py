#!/usr/bin/env python3
"""Tool-owned paired L2/L3 QA capture with strict identity and shutdown."""
from __future__ import annotations

import argparse
import ctypes
import ctypes.wintypes
import hashlib
import json
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

PROJECT_TOOLS = Path(__file__).resolve().parents[3] / "godot_game_dev" / "tools"
sys.path.insert(0, str(PROJECT_TOOLS))
from candidate_identity import calculate as calculate_candidate_identity

GODOT = Path(r"C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe")
CAPTURE = PROJECT_TOOLS / "capture_game_window.py"
WM_CLOSE = 0x0010
user32 = ctypes.windll.user32


def now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def parent_of(pid: int) -> int:
    class Entry(ctypes.Structure):
        _fields_ = [("dwSize", ctypes.c_ulong), ("cntUsage", ctypes.c_ulong), ("th32ProcessID", ctypes.c_ulong), ("th32DefaultHeapID", ctypes.POINTER(ctypes.c_ulong)), ("th32ModuleID", ctypes.c_ulong), ("cntThreads", ctypes.c_ulong), ("th32ParentProcessID", ctypes.c_ulong), ("pcPriClassBase", ctypes.c_long), ("dwFlags", ctypes.c_ulong), ("szExeFile", ctypes.c_wchar * 260)]
    snapshot = ctypes.windll.kernel32.CreateToolhelp32Snapshot(0x00000002, 0)
    if snapshot == -1: return -1
    try:
        entry = Entry(); entry.dwSize = ctypes.sizeof(Entry)
        ok = ctypes.windll.kernel32.Process32FirstW(snapshot, ctypes.byref(entry))
        while ok:
            if entry.th32ProcessID == pid: return entry.th32ParentProcessID
            ok = ctypes.windll.kernel32.Process32NextW(snapshot, ctypes.byref(entry))
    finally:
        ctypes.windll.kernel32.CloseHandle(snapshot)
    return -1


def owned_window(owner_pid: int):
    result = None
    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def callback(hwnd, _):
        nonlocal result
        if not user32.IsWindowVisible(hwnd): return True
        size = user32.GetWindowTextLengthW(hwnd)
        if not size: return True
        buffer = ctypes.create_unicode_buffer(size + 1); user32.GetWindowTextW(hwnd, buffer, size + 1)
        if "(debug)" not in buffer.value.lower(): return True
        pid = ctypes.wintypes.DWORD(); user32.GetWindowThreadProcessId(hwnd, ctypes.byref(pid))
        if pid.value and (pid.value == owner_pid or parent_of(pid.value) == owner_pid):
            rect = ctypes.wintypes.RECT(); user32.GetWindowRect(hwnd, ctypes.byref(rect))
            result = {"pid": pid.value, "hwnd": hwnd, "title": buffer.value, "rect": [rect.left, rect.top, rect.right, rect.bottom]}
        return True
    user32.EnumWindows(callback, 0)
    return result


def write(path: Path, record: dict) -> None:
    record["completed_at_utc"] = now()
    path.write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Safe paired L2/L3 QA capture.")
    parser.add_argument("--project-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--transaction-id", required=True)
    parser.add_argument("--candidate-identity-file", type=Path, required=True)
    parser.add_argument("--capture-profile", choices=["pulse", "arc-coil"], default="arc-coil")
    parser.add_argument("--window-timeout", type=float, default=20.0)
    parser.add_argument("--exit-timeout", type=float, default=10.0)
    args = parser.parse_args()
    root = args.project_root.resolve(); out = args.output_dir.resolve(); out.mkdir(parents=True, exist_ok=True)
    candidate = json.loads(args.candidate_identity_file.read_text(encoding="utf-8"))
    result_path = out / "paired_result.json"; log_path = out / "paired_runtime.log"
    record = {"schema_version": "paired-qa-capture-v2", "transaction_id": args.transaction_id, "candidate_identity": candidate, "project_root": str(root), "capture_profile": args.capture_profile, "route": "tool_owned_qa_scene_plus_native_window", "will_mutate_project": False, "force_kill_policy": "disabled", "close_attempted": False, "started_at_utc": now(), "proves": "same tool-owned transaction internal state/viewport plus native debug window identity/pixels", "does_not_prove": "real-player input, player enjoyment, generic gameplay quality, or user acceptance"}
    process = None; window = None
    try:
        if not root.joinpath("project.godot").is_file() or not GODOT.is_file(): raise RuntimeError("missing project or Godot executable")
        if calculate_candidate_identity(root) != candidate: raise RuntimeError("identity_mismatch: current project candidate differs from candidate identity file")
        scene = "res://qa/qa_runtime_viewport_capture.tscn"; qa_output = f"res://qa/evidence/{out.name}"
        process = subprocess.Popen([str(GODOT), "--path", str(root), scene, "--", f"--capture-tx={args.transaction_id}", f"--capture-identity-file={args.candidate_identity_file.resolve()}", f"--capture-profile={args.capture_profile}", f"--capture-out={qa_output}"], cwd=root, stdout=log_path.open("w", encoding="utf-8"), stderr=subprocess.STDOUT)
        record["console_pid"] = process.pid
        deadline = time.monotonic() + args.window_timeout
        while time.monotonic() < deadline:
            window = owned_window(process.pid)
            if window: break
            if process.poll() is not None: raise RuntimeError("QA scene exited before native window capture")
            time.sleep(0.15)
        if not window: raise RuntimeError("tool-owned QA debug window did not appear")
        user32.SetForegroundWindow(int(window["hwnd"])); time.sleep(0.25)
        state_path, viewport_path = out / "state.json", out / "viewport.png"
        deadline = time.monotonic() + args.window_timeout
        while time.monotonic() < deadline and (not state_path.is_file() or not viewport_path.is_file()): time.sleep(0.1)
        if not state_path.is_file() or not viewport_path.is_file(): raise RuntimeError("QA scene did not produce paired state.json and viewport.png")
        state = json.loads(state_path.read_text(encoding="utf-8"))
        if state.get("transaction_id") != args.transaction_id or state.get("candidate_identity") != candidate: raise RuntimeError("paired QA state identity mismatch")
        capture = subprocess.run([sys.executable, str(CAPTURE), "--pid", str(window["pid"]), "--output", str(out / "native_window.png"), "--project-root", str(root), "--scenario", "paired_qa_capture", "--state", str(state.get("state")), "--action", str(state.get("action")), "--manifest", str(out / "native_manifest.jsonl"), "--no-focus-steal", "--transaction-id", args.transaction_id, "--candidate-identity-file", str(args.candidate_identity_file)], text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if capture.returncode != 0: raise RuntimeError(capture.stderr.strip() or capture.stdout.strip())
        record["window_identity"] = {key: window[key] for key in ("pid", "hwnd", "title", "rect")}
        record["native_capture"] = json.loads(capture.stdout); record["state_summary"] = state
    except Exception as error:
        record.update(status="blocked", error=str(error), graceful_exit=False)
    finally:
        if process is not None and process.poll() is None and window is not None:
            record["close_attempted"] = bool(user32.PostMessageW(int(window["hwnd"]), WM_CLOSE, 0, 0))
            try: process.wait(timeout=args.exit_timeout)
            except subprocess.TimeoutExpired: record.update(status="blocked", error="QA scene did not exit after WM_CLOSE; force kill disabled", graceful_exit=False, unresponsive_pid=process.pid)
        if process is not None and process.poll() is not None:
            record["exit_code"] = process.returncode
            if process.returncode == 0 and "native_capture" in record and record.get("status") != "blocked": record.update(status="passed", graceful_exit=True, internal_state_sha256=sha256(state_path), viewport_sha256=sha256(viewport_path))
            elif process.returncode != 0: record.update(status="blocked", error="tool_owned_session_nonzero_exit", graceful_exit=False)
        elif process is not None:
            record.setdefault("unresolved_process_pid", process.pid); record.setdefault("status", "blocked"); record.setdefault("graceful_exit", False)
        write(result_path, record)
    print(json.dumps(record, ensure_ascii=False))
    return 0 if record.get("status") == "passed" else 2


if __name__ == "__main__":
    raise SystemExit(main())
