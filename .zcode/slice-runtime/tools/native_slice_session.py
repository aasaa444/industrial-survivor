#!/usr/bin/env python3
"""Tool-owned native Godot debug-window capture with strict identity and shutdown."""
from __future__ import annotations

import argparse
import ctypes
import ctypes.wintypes
import json
import subprocess
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

PROJECT_TOOLS = Path(__file__).resolve().parents[3] / "godot_game_dev" / "tools"
sys.path.insert(0, str(PROJECT_TOOLS))
from candidate_identity import calculate as calculate_candidate_identity

DEFAULT_GODOT = Path(r"C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe")
CAPTURE = PROJECT_TOOLS / "capture_game_window.py"
WM_CLOSE = 0x0010
user32 = ctypes.windll.user32


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def write_result(path: Path, record: dict[str, object]) -> None:
    record["completed_at_utc"] = utc_now()
    path.write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def parent_of_pid(pid: int) -> int:
    class ProcessEntry(ctypes.Structure):
        _fields_ = [("dwSize", ctypes.c_ulong), ("cntUsage", ctypes.c_ulong), ("th32ProcessID", ctypes.c_ulong), ("th32DefaultHeapID", ctypes.POINTER(ctypes.c_ulong)), ("th32ModuleID", ctypes.c_ulong), ("cntThreads", ctypes.c_ulong), ("th32ParentProcessID", ctypes.c_ulong), ("pcPriClassBase", ctypes.c_long), ("dwFlags", ctypes.c_ulong), ("szExeFile", ctypes.c_wchar * 260)]
    snapshot = ctypes.windll.kernel32.CreateToolhelp32Snapshot(0x00000002, 0)
    if snapshot == -1:
        return -1
    try:
        entry = ProcessEntry(); entry.dwSize = ctypes.sizeof(ProcessEntry)
        found = ctypes.windll.kernel32.Process32FirstW(snapshot, ctypes.byref(entry))
        while found:
            if entry.th32ProcessID == pid:
                return entry.th32ParentProcessID
            found = ctypes.windll.kernel32.Process32NextW(snapshot, ctypes.byref(entry))
    finally:
        ctypes.windll.kernel32.CloseHandle(snapshot)
    return -1


def find_owned_window(console_pid: int) -> dict[str, object] | None:
    result: dict[str, object] | None = None
    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def callback(hwnd: int, _: int) -> bool:
        nonlocal result
        if not user32.IsWindowVisible(hwnd): return True
        length = user32.GetWindowTextLengthW(hwnd)
        if length == 0: return True
        buffer = ctypes.create_unicode_buffer(length + 1)
        user32.GetWindowTextW(hwnd, buffer, length + 1)
        if "(debug)" not in buffer.value.lower(): return True
        pid = ctypes.wintypes.DWORD(); user32.GetWindowThreadProcessId(hwnd, ctypes.byref(pid))
        if pid.value and parent_of_pid(pid.value) == console_pid:
            rect = ctypes.wintypes.RECT(); user32.GetWindowRect(hwnd, ctypes.byref(rect))
            result = {"pid": pid.value, "hwnd": hwnd, "title": buffer.value, "rect": [rect.left, rect.top, rect.right, rect.bottom]}
        return True
    user32.EnumWindows(callback, 0)
    return result


def wait_for_owned_window(console_pid: int, timeout: float) -> dict[str, object]:
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        window = find_owned_window(console_pid)
        if window: return window
        time.sleep(0.25)
    raise RuntimeError("tool-owned debug window did not appear")


def main() -> int:
    parser = argparse.ArgumentParser(description="Safe tool-owned native Godot window capture.")
    parser.add_argument("--project-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--transaction-id", required=True)
    parser.add_argument("--candidate-identity-file", type=Path, required=True)
    parser.add_argument("--scenario", default="launch_capture")
    parser.add_argument("--state", default="clean_launch")
    parser.add_argument("--action", default="wait_stable_frame")
    parser.add_argument("--godot", type=Path, default=DEFAULT_GODOT)
    parser.add_argument("--window-timeout", type=float, default=25.0)
    parser.add_argument("--exit-timeout", type=float, default=10.0)
    args = parser.parse_args()
    project = args.project_root.resolve(); output = args.output_dir.resolve(); output.mkdir(parents=True, exist_ok=True)
    result_path = output / "session_result.json"; log_path = output / "session_runtime.log"
    candidate = json.loads(args.candidate_identity_file.read_text(encoding="utf-8"))
    record: dict[str, object] = {"schema_version": "native-slice-session-v2", "transaction_id": args.transaction_id, "candidate_identity": candidate, "project_root": str(project), "started_at_utc": utc_now(), "route": "tool_owned_native_window", "proves": "caller-owned native debug window identity and visible pixels", "does_not_prove": "authoritative game business state, player experience, or user acceptance", "will_mutate_project": False, "force_kill_policy": "disabled", "close_attempted": False}
    process = None; window = None
    try:
        if not project.joinpath("project.godot").is_file(): raise RuntimeError("project.godot missing")
        if not args.godot.is_file(): raise RuntimeError("Godot console executable missing")
        if calculate_candidate_identity(project) != candidate: raise RuntimeError("identity_mismatch: current project candidate differs from candidate identity file")
        process = subprocess.Popen([str(args.godot), "--path", str(project)], cwd=project, stdout=log_path.open("w", encoding="utf-8"), stderr=subprocess.STDOUT)
        record["console_pid"] = process.pid
        window = wait_for_owned_window(process.pid, args.window_timeout)
        record["window_identity"] = {key: window[key] for key in ("pid", "hwnd", "title", "rect")}
        user32.SetForegroundWindow(int(window["hwnd"])); time.sleep(0.25)
        capture = subprocess.run([sys.executable, str(CAPTURE), "--pid", str(window["pid"]), "--output", str(output / "native_window.png"), "--project-root", str(project), "--scenario", args.scenario, "--state", args.state, "--action", args.action, "--manifest", str(output / "native_manifest.jsonl"), "--no-focus-steal", "--transaction-id", args.transaction_id, "--candidate-identity-file", str(args.candidate_identity_file)], text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if capture.returncode != 0: raise RuntimeError(f"native capture rejected: {capture.stderr.strip() or capture.stdout.strip()}")
        record["capture"] = json.loads(capture.stdout)
    except Exception as error:
        record.update(status="blocked", error=str(error), graceful_exit=False)
    finally:
        if process is not None and process.poll() is None and window is not None:
            record["close_attempted"] = bool(user32.PostMessageW(int(window["hwnd"]), WM_CLOSE, 0, 0))
            try: process.wait(timeout=args.exit_timeout)
            except subprocess.TimeoutExpired: record.update(status="blocked", error="tool-owned process did not exit after WM_CLOSE; force kill disabled", graceful_exit=False, unresponsive_pid=process.pid)
        if process is not None and process.poll() is not None:
            record["exit_code"] = process.returncode
            if process.returncode == 0 and "capture" in record and record.get("status") != "blocked": record.update(status="passed", graceful_exit=True)
            elif process.returncode != 0: record.update(status="blocked", error="tool_owned_session_nonzero_exit", graceful_exit=False)
        elif process is not None:
            record.setdefault("unresolved_process_pid", process.pid)
            record.setdefault("status", "blocked")
            record.setdefault("graceful_exit", False)
        write_result(result_path, record)
    print(json.dumps(record, ensure_ascii=False))
    return 0 if record.get("status") == "passed" else 2


if __name__ == "__main__":
    raise SystemExit(main())
