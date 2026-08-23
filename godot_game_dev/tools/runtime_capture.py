#!/usr/bin/env python3
"""Arc Coil L2 viewport capture with strict candidate identity.

This tool owns a windowed QA session because viewport pixels require rendering. It never
captures native desktop pixels and never force-kills an unresponsive Godot child.
"""
from __future__ import annotations
import argparse, hashlib, json, platform, subprocess, sys, uuid
from datetime import datetime, timezone
from pathlib import Path

TOOL_VERSION = "runtime-capture-v2"
DEFAULT_GODOT = Path(r"C:\Users\User\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def reject(message: str, output: Path | None = None, record: dict | None = None) -> int:
    result = {"schema_version": TOOL_VERSION, "status": "rejected", "error": message, "exit_code": 2}
    if record:
        result.update(record)
    if output:
        output.mkdir(parents=True, exist_ok=True)
        (output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result, ensure_ascii=False))
    return 2


def validate_artifact(out: Path, transaction_id: str, candidate: dict, profile: str) -> dict:
    state_path, image_path = out / "state.json", out / "viewport.png"
    if not state_path.is_file() or not image_path.is_file(): raise ValueError("missing state.json or viewport.png")
    state = json.loads(state_path.read_text(encoding="utf-8"))
    required = ["capture_id", "transaction_id", "candidate_identity", "scenario", "state", "action", "progression", "build", "upgrade_ui", "alive_enemies", "camera_position", "recent_input", "proves", "does_not_prove"]
    missing = [key for key in required if key not in state]
    if missing: raise ValueError("state metadata missing: " + ", ".join(missing))
    if state["transaction_id"] != transaction_id: raise ValueError("transaction_id mismatch")
    if state["candidate_identity"] != candidate: raise ValueError("candidate identity mismatch")
    if profile != "arc-coil": raise ValueError("pulse profile is legacy_identity_partial and not supported by runtime-capture-v2")
    if state["state"] != "arc_coil_chain_active": raise ValueError("Arc Coil chain state not active")
    if str(state.get("build", {}).get("weapon_id", "")) != "arc_coil": raise ValueError("active weapon is not arc_coil")
    trace = state.get("arc_coil_trace", [])
    if len(trace) < 2 or int(trace[0].get("hop", -1)) != 0 or int(trace[1].get("hop", -1)) != 1: raise ValueError("Arc Coil hop 0/1 trace missing")
    if int(state.get("arc_coil_vfx_nodes", 0)) < 2: raise ValueError("Arc Coil VFX nodes not active")
    return {"state": state, "viewport_sha256": sha256(image_path), "state_sha256": sha256(state_path)}


def load_candidate(path: Path) -> dict:
    candidate = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(candidate, dict) or candidate.get("identity_version") != "git-worktree-v2" or not candidate.get("working_tree_sha256"):
        raise ValueError("candidate identity file must contain a git-worktree-v2 identity object")
    return candidate


def main() -> int:
    parser = argparse.ArgumentParser(description="State-bound Arc Coil viewport capture.")
    parser.add_argument("--project-root", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--transaction-id")
    parser.add_argument("--candidate-identity-file", type=Path)
    parser.add_argument("--profile", choices=["arc-coil", "pulse"], default="arc-coil")
    parser.add_argument("--godot", type=Path, default=DEFAULT_GODOT)
    parser.add_argument("--mode", choices=["viewport", "validate"], default="viewport")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--negative-fixture", choices=["wrong-sha", "missing-artifact"])
    args = parser.parse_args(); root = args.project_root.resolve(); out = args.output_dir.resolve()
    transaction_id = args.transaction_id or f"capture-{uuid.uuid4().hex[:12]}"
    if args.candidate_identity_file is None:
        return reject("candidate identity file is required", out)
    try:
        candidate = load_candidate(args.candidate_identity_file)
    except (OSError, json.JSONDecodeError, ValueError) as error:
        return reject(str(error), out)
    expected_output = (root / "qa" / "evidence" / out.name).resolve()
    plan = {"schema_version": TOOL_VERSION, "tool_version": TOOL_VERSION, "mode": args.mode, "profile": args.profile, "project_root": str(root), "output_dir": str(out), "transaction_id": transaction_id, "candidate_identity": candidate, "godot": str(args.godot), "capture_routes": ["game_internal_viewport"], "native_window_route": "separate protected native capture route", "proves": "authoritative Arc Coil chain state + internal viewport frame", "does_not_prove": "foreground native-window pixels, player experience, or user acceptance", "will_mutate_project": False, "force_kill_policy": "disabled", "negative_checks": {"wrong_sha": "not_run", "missing_artifact": "not_run"}, "platform": platform.platform()}
    if args.dry_run:
        print(json.dumps({**plan, "status": "dry_run", "exit_code": 0}, ensure_ascii=False, indent=2)); return 0
    if args.profile != "arc-coil": return reject("pulse profile is legacy_identity_partial; recollect Arc Coil v2 evidence", out, plan)
    if out != expected_output: return reject("output-dir must equal project qa/evidence/<capture-id>", out, plan)
    if not root.joinpath("project.godot").is_file(): return reject("project.godot missing under project root", out, plan)
    if not args.godot.is_file(): return reject("Godot binary missing", out, plan)
    if args.negative_fixture == "missing-artifact": return reject("negative fixture: artifacts intentionally absent", out, plan)
    if args.mode == "viewport":
        if out.exists() and any(out.iterdir()): return reject("output directory is not empty; stale reuse forbidden", out, plan)
        out.mkdir(parents=True, exist_ok=True)
        identity_path = args.candidate_identity_file.resolve()
        process = subprocess.Popen([str(args.godot), "--path", str(root), "res://qa/qa_runtime_viewport_capture.tscn", "--", f"--capture-tx={transaction_id}", f"--capture-identity-file={identity_path}", f"--capture-profile=arc-coil", f"--capture-out=res://qa/evidence/{out.name}"], cwd=root, stdout=(out / "runtime.log").open("w", encoding="utf-8"), stderr=subprocess.STDOUT)
        plan["console_pid"] = process.pid
        try:
            exit_code = process.wait(timeout=45)
        except subprocess.TimeoutExpired:
            return reject("QA-owned process did not exit normally within 45 seconds; force kill disabled", out, {**plan, "status": "blocked", "unresponsive_pid": process.pid})
        if exit_code != 0: return reject("QA viewport scene failed; see runtime.log", out, {**plan, "child_exit_code": exit_code})
    try:
        verified = validate_artifact(out, transaction_id, candidate, args.profile)
    except Exception as error:
        return reject(str(error), out, plan)
    manifest = {**plan, "status": "passed", "captured_at_utc": datetime.now(timezone.utc).isoformat(), "viewport_png": str((out / "viewport.png").resolve()), "state_json": str((out / "state.json").resolve()), "runtime_log": str((out / "runtime.log").resolve()), "viewport_sha256": verified["viewport_sha256"], "state_sha256": verified["state_sha256"], "state_summary": verified["state"], "exit_code": 0, "graceful_exit": True, "evidence_boundary": "internal state/render only; pair with protected native capture for L3"}
    (out / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest, ensure_ascii=False, indent=2)); return 0


if __name__ == "__main__":
    try: raise SystemExit(main())
    except (OSError, json.JSONDecodeError) as error: raise SystemExit(reject(str(error)))
