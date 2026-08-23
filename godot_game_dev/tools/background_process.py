#!/usr/bin/env python3
"""Structured launcher for non-interactive New_Game subprocesses.

It hides only console hosts it creates. It never launches foreground game sessions,
injects input, captures desktop pixels, or terminates an unresponsive child.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import subprocess
import sys
import uuid
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

SENSITIVE_FLAGS = {"--token", "--secret", "--password", "--passwd", "--authorization", "--credential", "--api-key", "--apikey"}
FORBIDDEN_ARGS = {"--allow-real-input", "--foreground", "--capture", "--native-window", "--windowed"}
TIMEOUT_EXIT_CODE = 124
LAUNCHER_ERROR_EXIT_CODE = 2


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def sha256_file(path: Path) -> str | None:
    return sha256_bytes(path.read_bytes()) if path.is_file() else None


def redact_argv(argv: list[str]) -> list[str]:
    redacted: list[str] = []
    redact_next = False
    for arg in argv:
        lower = arg.lower()
        if redact_next:
            redacted.append("<redacted>")
            redact_next = False
        elif lower in SENSITIVE_FLAGS:
            redacted.append(arg)
            redact_next = True
        else:
            matched = next((flag for flag in SENSITIVE_FLAGS if lower.startswith(f"{flag}=")), None)
            redacted.append(f"{arg[:len(matched)]}=<redacted>" if matched else arg)
    return redacted


def validate(profile: str, argv: list[str], project_root: Path) -> None:
    if not argv:
        raise ValueError("argv must be non-empty")
    if any(arg.lower() in FORBIDDEN_ARGS for arg in argv):
        raise ValueError("foreground/input/capture arguments are forbidden in background_process")
    executable = Path(argv[0]).resolve()
    if profile == "gdmcp":
        expected = (project_root / ".gdmcp" / "bin" / "gdmcp.exe").resolve()
        if executable != expected:
            raise ValueError("gdmcp profile requires the project-local .gdmcp/bin/gdmcp.exe")
    elif profile == "headless_godot":
        if "--headless" not in argv:
            raise ValueError("headless_godot profile requires --headless")
    elif profile != "generic":
        raise ValueError(f"unsupported profile: {profile}")


def write_record(path: Path, record: dict[str, Any]) -> None:
    path.write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def finalize_record(record: dict[str, Any], stdout_path: Path, stderr_path: Path) -> None:
    record["completed_at_utc"] = utc_now()
    record["stdout_sha256"] = sha256_file(stdout_path)
    record["stderr_sha256"] = sha256_file(stderr_path)
    if record.get("status") == "passed" or record.get("status") == "failed":
        record["launcher_exit_code"] = record["child_exit_code"]
        record["result_source"] = "child"
    elif record.get("status") == "blocked":
        record["launcher_exit_code"] = TIMEOUT_EXIT_CODE if record.get("result_source") == "timeout" else LAUNCHER_ERROR_EXIT_CODE


def run(profile: str, argv: list[str], cwd: Path, log_dir: Path, label: str, quiet_host: bool, timeout: float | None) -> dict[str, Any]:
    validate(profile, argv, cwd)
    if not cwd.is_dir():
        raise ValueError(f"cwd does not exist: {cwd}")
    log_dir.mkdir(parents=True, exist_ok=True)
    session_id = f"BG-{uuid.uuid4().hex[:12]}"
    stdout_path = log_dir / f"{session_id}.stdout.log"
    stderr_path = log_dir / f"{session_id}.stderr.log"
    record_path = log_dir / f"{session_id}.json"
    creationflags = getattr(subprocess, "CREATE_NO_WINDOW", 0) if quiet_host and os.name == "nt" else 0
    redacted_argv = redact_argv(argv)
    record: dict[str, Any] = {
        "schema_version": "background-process-v2",
        "session_id": session_id,
        "label": label,
        "profile": profile,
        "started_at_utc": utc_now(),
        "owner_id": session_id,
        "launcher_pid": os.getpid(),
        "cwd": str(cwd),
        "argv": redacted_argv,
        "argv_sha256": sha256_bytes(json.dumps(redacted_argv, separators=(",", ":")).encode("utf-8")),
        "quiet_host": quiet_host,
        "creationflags": creationflags,
        "stdout": str(stdout_path),
        "stderr": str(stderr_path),
        "kill_policy": "disabled",
        "timeout_seconds": timeout,
        "child_pid": None,
        "child_exit_code": None,
        "child_state": "not_started",
        "reconcile_status": "not_needed",
        "result_source": "launcher",
    }
    try:
        with stdout_path.open("w", encoding="utf-8", errors="replace") as stdout, stderr_path.open("w", encoding="utf-8", errors="replace") as stderr:
            process = subprocess.Popen(argv, cwd=cwd, stdout=stdout, stderr=stderr, text=True, creationflags=creationflags)
            record["child_pid"] = process.pid
            record["child_start_observed_at_utc"] = utc_now()
            try:
                exit_code = process.wait(timeout=timeout)
                record["child_exit_code"] = exit_code
                record["child_state"] = "exited"
                record["reconcile_status"] = "resolved"
                record["status"] = "passed" if exit_code == 0 else "failed"
            except subprocess.TimeoutExpired:
                record["timeout_observed_at_utc"] = utc_now()
                try:
                    observed = process.wait(timeout=0.25)
                except subprocess.TimeoutExpired:
                    observed = process.poll()
                record["status"] = "blocked"
                record["result_source"] = "timeout"
                record["child_exit_code"] = observed
                record["child_state"] = "exited" if observed is not None else "running"
                record["reconcile_status"] = "resolved" if observed is not None else "pending"
                record["error"] = "child exceeded timeout; force kill disabled"
    except OSError as error:
        record.update(status="blocked", error=str(error), child_state="not_started", reconcile_status="not_needed", result_source="launcher")
    finalize_record(record, stdout_path, stderr_path)
    write_record(record_path, record)
    return record


def reconcile(record_path: Path) -> dict[str, Any]:
    record = json.loads(record_path.read_text(encoding="utf-8"))
    if record.get("schema_version") != "background-process-v2":
        raise ValueError("unsupported session record schema")
    if record.get("reconcile_status") != "pending":
        return record
    pid = record.get("child_pid")
    if not isinstance(pid, int) or pid <= 0:
        record["reconcile_status"] = "identity_unknown"
        record["child_state"] = "unknown"
        write_record(record_path, record)
        return record
    try:
        os.kill(pid, 0)
        record["child_state"] = "running"
        record["reconcile_status"] = "pending"
    except ProcessLookupError:
        record["child_state"] = "exited_unobserved"
        record["reconcile_status"] = "resolved"
    except PermissionError:
        record["child_state"] = "identity_unknown"
        record["reconcile_status"] = "identity_unknown"
    except OSError as error:
        record["child_state"] = "identity_unknown"
        record["reconcile_status"] = "identity_unknown"
        record["reconcile_error"] = str(error)
    record["reconciled_at_utc"] = utc_now()
    write_record(record_path, record)
    return record


def main() -> int:
    parser = argparse.ArgumentParser(description="Run a non-interactive project subprocess with an optional hidden console host.")
    sub = parser.add_subparsers(dest="command", required=True)
    run_parser = sub.add_parser("run")
    run_parser.add_argument("--profile", choices=["gdmcp", "headless_godot", "generic"], required=True)
    run_parser.add_argument("--cwd", type=Path, required=True)
    run_parser.add_argument("--log-dir", type=Path, required=True)
    run_parser.add_argument("--label", required=True)
    run_parser.add_argument("--show-host", action="store_true", help="Show the child console host for debugging.")
    run_parser.add_argument("--timeout-seconds", type=float)
    run_parser.add_argument("argv", nargs=argparse.REMAINDER, help="Use -- before the child executable and args.")
    reconcile_parser = sub.add_parser("reconcile")
    reconcile_parser.add_argument("--record", type=Path, required=True)
    args = parser.parse_args()
    try:
        if args.command == "reconcile":
            record = reconcile(args.record.resolve())
            print(json.dumps({"status": record.get("status"), "child_state": record.get("child_state"), "reconcile_status": record.get("reconcile_status"), "record": str(args.record.resolve())}, ensure_ascii=False))
            return 0 if record.get("reconcile_status") == "resolved" else TIMEOUT_EXIT_CODE
        argv = args.argv[1:] if args.argv[:1] == ["--"] else args.argv
        record = run(args.profile, argv, args.cwd.resolve(), args.log_dir.resolve(), args.label, not args.show_host, args.timeout_seconds)
        record_path = args.log_dir.resolve() / f"{record['session_id']}.json"
        print(json.dumps({"status": record["status"], "session_id": record["session_id"], "child_exit_code": record["child_exit_code"], "launcher_exit_code": record["launcher_exit_code"], "record": str(record_path)}, ensure_ascii=False))
        return int(record["launcher_exit_code"])
    except ValueError as error:
        print(json.dumps({"status": "blocked", "error": str(error)}), file=sys.stderr)
        return LAUNCHER_ERROR_EXIT_CODE


if __name__ == "__main__":
    raise SystemExit(main())
