#!/usr/bin/env python3
"""GodotMaker-style project feedback loop for non-interactive validation.

This is an orchestrator over background_process.py, not a second launcher. It
checks the current project's compile/parse surface, boots the configured main
scene with the project's deterministic self-test contract, and optionally runs
one declared target command only after both project gates pass.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Callable

TOOLS = Path(__file__).resolve().parent
sys.path.insert(0, str(TOOLS))
import background_process
try:
    from candidate_identity import calculate as calculate_candidate_identity
except ImportError:
    calculate_candidate_identity = None

ERROR_MARKERS = (
    "Parse Error",
    "SCRIPT ERROR",
    "Resource file not found",
    "Failed to load",
    "Cannot get class",
    "scene file is invalid",
)

Runner = Callable[[str, list[str], Path, Path, str, bool, float | None], dict[str, Any]]


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def parse_main_scene(project_file: Path) -> str:
    text = project_file.read_text(encoding="utf-8", errors="replace")
    match = re.search(r"^run/main_scene=(?:\"([^\"]+)\"|([^\r\n]+))$", text, re.MULTILINE)
    if not match:
        raise ValueError("project.godot does not declare run/main_scene")
    scene = (match.group(1) or match.group(2)).strip()
    if not scene.startswith("res://"):
        raise ValueError(f"run/main_scene is not a res:// path: {scene}")
    return scene


def read_output(record: dict[str, Any]) -> tuple[str, str]:
    stdout = Path(str(record["stdout"])).read_text(encoding="utf-8", errors="replace")
    stderr = Path(str(record["stderr"])).read_text(encoding="utf-8", errors="replace")
    return stdout, stderr


def markers_in(stdout: str, stderr: str) -> list[str]:
    text = f"{stdout}\n{stderr}"
    return [marker for marker in ERROR_MARKERS if marker.lower() in text.lower()]


def session_record_path(record: dict[str, Any]) -> str:
    stdout_path = Path(str(record["stdout"]))
    return str(stdout_path.parent / f"{record['session_id']}.json")


def stage_result(record: dict[str, Any], stage: str, command: list[str]) -> dict[str, Any]:
    stdout, stderr = read_output(record)
    markers = markers_in(stdout, stderr)
    child_code = record.get("child_exit_code")
    status = "passed" if record.get("status") == "passed" and child_code == 0 and not markers else "failed"
    if record.get("status") == "blocked":
        status = "blocked"
    return {
        "stage": stage,
        "status": status,
        "command": command,
        "launcher_status": record.get("status"),
        "launcher_exit_code": record.get("launcher_exit_code"),
        "child_exit_code": child_code,
        "result_source": record.get("result_source"),
        "session_id": record.get("session_id"),
        "session_record": session_record_path(record),
        "stdout_ref": record.get("stdout"),
        "stderr_ref": record.get("stderr"),
        "error_markers": markers,
        "observed_at_utc": utc_now(),
        "proves": [f"{stage} child result for the current candidate"],
        "does_not_prove": ["player experience", "visual/audio quality", "user acceptance"],
    }


def blocked_stage(stage: str, error: str) -> dict[str, Any]:
    return {
        "stage": stage,
        "status": "blocked",
        "error": error,
        "proves": [],
        "does_not_prove": ["Godot project success", "player experience", "user acceptance"],
    }


def run_feedback_loop(
    project_root: Path,
    godot: Path,
    log_dir: Path,
    task_id: str = "project-feedback",
    change_step_id: str = "step-001",
    target_argv: list[str] | None = None,
    timeout: float = 120.0,
    runner: Runner | None = None,
    candidate_identity: dict[str, Any] | None = None,
) -> dict[str, Any]:
    root = project_root.resolve()
    godot = godot.resolve()
    log_dir = log_dir.resolve()
    run_child = runner or background_process.run
    receipt: dict[str, Any] = {
        "schema_version": "project-feedback-receipt-v1",
        "task_id": task_id,
        "change_step_id": change_step_id,
        "project_root": str(root),
        "candidate_identity": candidate_identity,
        "started_at_utc": utc_now(),
        "launcher": {"status": "not_run", "exit_code": None, "result_source": None, "session_ref": None},
        "godot": {"project_compile": "not_run", "active_scene_boot": "not_run", "child_exit_code": None, "stages": []},
        "mechanical": {"status": "not_run", "target_tests": "not_run"},
        "architecture": {"status": "not_run"},
        "player": {"status": "not_run"},
        "user_acceptance": {"status": "not_requested"},
        "final": {"status": "blocked", "next_safe_action": "run project feedback loop"},
        "proves": [],
        "does_not_prove": ["foreground input", "native L3 capture", "player experience", "user acceptance"],
    }

    try:
        if not (root / "project.godot").is_file():
            raise ValueError(f"project.godot not found under {root}")
        if not godot.is_file():
            raise ValueError(f"Godot executable not found: {godot}")
        scene = parse_main_scene(root / "project.godot")
    except (OSError, ValueError) as error:
        receipt["launcher"].update(status="blocked", exit_code=background_process.LAUNCHER_ERROR_EXIT_CODE, result_source="launcher")
        receipt["final"] = {"status": "blocked", "next_safe_action": str(error)}
        receipt["error"] = str(error)
        receipt["completed_at_utc"] = utc_now()
        return receipt

    commands = [
        ("project_compile", [str(godot), "--headless", "--editor", "--quit", "--path", str(root)]),
        ("active_scene_boot", [str(godot), "--headless", "--path", str(root), scene, "--quit-after", "3"]),
    ]
    for stage, command in commands:
        try:
            record = run_child("headless_godot", command, root, log_dir, stage, True, timeout)
        except (OSError, ValueError) as error:
            result = blocked_stage(stage, str(error))
            receipt["godot"]["stages"].append(result)
            receipt["godot"]["project_compile" if stage == "project_compile" else "active_scene_boot"] = "blocked"
            receipt["launcher"].update(status="blocked", exit_code=background_process.LAUNCHER_ERROR_EXIT_CODE, result_source="launcher")
            receipt["final"] = {"status": "blocked", "next_safe_action": str(error)}
            receipt["completed_at_utc"] = utc_now()
            return receipt
        result = stage_result(record, stage, command)
        receipt["godot"]["stages"].append(result)
        receipt["launcher"] = {
            "status": record.get("status"),
            "exit_code": record.get("launcher_exit_code"),
            "result_source": record.get("result_source"),
            "session_ref": result.get("session_record"),
        }
        receipt["godot"]["child_exit_code"] = record.get("child_exit_code")
        receipt["godot"]["project_compile" if stage == "project_compile" else "active_scene_boot"] = result["status"]
        if result["status"] != "passed":
            receipt["final"] = {"status": "blocked", "next_safe_action": f"resolve {stage} failure from {result.get('stderr_ref')}"}
            receipt["completed_at_utc"] = utc_now()
            return receipt

    if target_argv:
        try:
            record = run_child("generic", target_argv, root, log_dir, "target-tests", True, timeout)
            target = stage_result(record, "target_tests", target_argv)
        except (OSError, ValueError) as error:
            target = blocked_stage("target_tests", str(error))
        receipt["mechanical"]["target_tests"] = target["status"]
        receipt["mechanical"]["target_result"] = target
        receipt["launcher"] = {
            "status": target.get("launcher_status"),
            "exit_code": target.get("launcher_exit_code"),
            "result_source": target.get("result_source"),
            "session_ref": target.get("session_record"),
        }
        if target["status"] != "passed":
            receipt["final"] = {"status": "blocked", "next_safe_action": "resolve target test failure before Mechanical Gate"}
            receipt["completed_at_utc"] = utc_now()
            return receipt
    else:
        receipt["mechanical"]["target_tests"] = "not_run"
        receipt["mechanical"]["target_tests_reason"] = "no target command declared"

    receipt["final"] = {
        "status": "passed",
        "next_safe_action": "proceed to declared Mechanical Gate; Player Gate remains separate",
    }
    receipt["proves"] = ["current project compile/parse result", "configured active scene boot result"]
    if target_argv:
        receipt["proves"].append("declared target test result")
    receipt["completed_at_utc"] = utc_now()
    return receipt


def main() -> int:
    parser = argparse.ArgumentParser(description="Run project compile and active-scene feedback through background_process.py.")
    parser.add_argument("--project-root", type=Path, required=True)
    parser.add_argument("--godot", type=Path, required=True)
    parser.add_argument("--log-dir", type=Path, required=True)
    parser.add_argument("--task-id", default="project-feedback")
    parser.add_argument("--change-step-id", default="step-001")
    parser.add_argument("--timeout-seconds", type=float, default=120.0)
    parser.add_argument("--target-command", nargs=argparse.REMAINDER)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    target = args.target_command or None
    if target and target[:1] == ["--"]:
        target = target[1:]
    receipt = run_feedback_loop(args.project_root, args.godot, args.log_dir, args.task_id, args.change_step_id, target, args.timeout_seconds, candidate_identity=(calculate_candidate_identity(args.project_root) if calculate_candidate_identity else None))
    output = args.output.resolve() if args.output else args.log_dir.resolve() / f"{args.task_id}-{args.change_step_id}-receipt.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"status": receipt["final"]["status"], "receipt": str(output), "compile": receipt["godot"]["project_compile"], "boot": receipt["godot"]["active_scene_boot"], "target_tests": receipt["mechanical"]["target_tests"]}, ensure_ascii=False))
    return 0 if receipt["final"]["status"] == "passed" else int(receipt["launcher"].get("exit_code") or 2)


if __name__ == "__main__":
    raise SystemExit(main())
