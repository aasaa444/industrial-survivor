#!/usr/bin/env python3
"""Project-local Slice Runtime v1.

The runtime records and validates playable-slice state without deciding product
quality. It never mutates Godot production files and it never infers user
acceptance.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

PROJECT_TOOLS = Path(__file__).resolve().parents[3] / "godot_game_dev" / "tools"
sys.path.insert(0, str(PROJECT_TOOLS))
from candidate_identity import calculate as calculate_candidate_identity

SCHEMA = "slice-runtime-v1"
ACTIVE_STATES = {"scoped", "building", "mechanically_verified", "player_evaluated", "user_acceptance_pending"}
STATES = ACTIVE_STATES | {"accepted", "remediation_required", "paused", "blocked"}
TRANSITIONS = {
    "scoped": {"building", "blocked", "paused"},
    "building": {"mechanically_verified", "blocked", "paused"},
    "mechanically_verified": {"player_evaluated", "blocked", "remediation_required", "paused"},
    "player_evaluated": {"user_acceptance_pending", "remediation_required", "blocked", "paused"},
    "user_acceptance_pending": {"accepted", "remediation_required", "paused", "blocked"},
    "remediation_required": {"building", "paused", "blocked"},
    "blocked": {"scoped", "building", "paused"},
    "paused": {"scoped"},
    "accepted": set(),
}
ROLE_FOR_TRANSITION = {
    ("scoped", "building"): {"builder"},
    ("building", "mechanically_verified"): {"mechanical_qa"},
    ("mechanically_verified", "player_evaluated"): {"evaluator"},
    ("player_evaluated", "user_acceptance_pending"): {"scope", "lead"},
    ("user_acceptance_pending", "accepted"): {"user"},
    ("user_acceptance_pending", "remediation_required"): {"user"},
    ("user_acceptance_pending", "paused"): {"user"},
    ("remediation_required", "building"): {"builder"},
    ("paused", "scoped"): {"scope", "user"},
    ("blocked", "scoped"): {"scope", "user"},
    ("blocked", "building"): {"builder"},
    ("blocked", "paused"): {"user", "scope"},
}


def now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def fail(message: str) -> None:
    raise ValueError(message)


def read_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        fail(f"missing file: {path}")
    except json.JSONDecodeError as error:
        fail(f"invalid JSON {path}: {error}")
    if not isinstance(value, dict):
        fail(f"JSON object required: {path}")
    return value


def write_json(path: Path, value: dict[str, Any]) -> None:
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def command_output(args: list[str], cwd: Path) -> tuple[int, str]:
    process = subprocess.run(args, cwd=cwd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return process.returncode, process.stdout


def candidate_identity(project_root: Path) -> dict[str, Any]:
    return calculate_candidate_identity(project_root)


def slice_contract_sha256(slice_data: dict[str, Any]) -> str:
    canonical = {key: value for key, value in slice_data.items() if key != "slice_contract_sha256"}
    return hashlib.sha256(json.dumps(canonical, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode("utf-8")).hexdigest()


def runtime_paths(slice_dir: Path) -> dict[str, Path]:
    return {
        "slice": slice_dir / "slice.json",
        "state": slice_dir / "state.json",
        "events": slice_dir / "events.jsonl",
        "manifest": slice_dir / "manifest.json",
        "repair": slice_dir / "repair.json",
        "evaluations": slice_dir / "evaluations",
        "transitions": slice_dir / "transitions.json",
    }


def append_event(paths: dict[str, Path], state: dict[str, Any], old: str | None, new: str, role: str, reason: str, artifacts: list[str] | None = None) -> None:
    state["transition_seq"] += 1
    event = {
        "event_id": f"EV-{state['transition_seq']:04d}",
        "ts_utc": now(),
        "seq": state["transition_seq"],
        "from": old,
        "to": new,
        "role": role,
        "reason": reason,
        "artifacts": artifacts or [],
        "candidate_identity": state["candidate_identity"],
    }
    with paths["events"].open("a", encoding="utf-8") as stream:
        stream.write(json.dumps(event, ensure_ascii=False) + "\n")
    state["last_event_id"] = event["event_id"]


def validate_slice(slice_data: dict[str, Any]) -> None:
    if slice_data.get("schema_version") != SCHEMA:
        fail("unsupported slice schema")
    if not isinstance(slice_data.get("slice_id"), str) or not slice_data["slice_id"]:
        fail("slice_id is required")
    if not isinstance(slice_data.get("player_promise"), str) or not slice_data["player_promise"]:
        fail("one player_promise is required")
    units = slice_data.get("playable_units")
    if not isinstance(units, list) or not 1 <= len(units) <= 3:
        fail("playable_units must contain one to three rows")
    required = {"id", "action", "state_owner", "effect", "feedback", "pressure", "terminal_or_reset"}
    ids = set()
    for unit in units:
        if not isinstance(unit, dict) or required - set(unit):
            fail("every playable unit requires id/action/state_owner/effect/feedback/pressure/terminal_or_reset")
        if unit["id"] in ids:
            fail("playable unit IDs must be unique")
        ids.add(unit["id"])
    if slice_data.get("acceptance_authority") != "user":
        fail("acceptance_authority must be user")


def start(args: argparse.Namespace) -> None:
    slice_dir = Path(args.slice_dir).resolve()
    if slice_dir.exists() and any(slice_dir.iterdir()):
        fail("slice directory already exists and is non-empty")
    project_root = Path(args.project_root).resolve()
    units = json.loads(Path(args.units_json).read_text(encoding="utf-8"))
    slice_data = {
        "schema_version": SCHEMA,
        "slice_id": args.slice_id,
        "player_promise": args.player_promise,
        "playable_units": units,
        "project_root": str(project_root).replace("\\", "/"),
        "route_class": args.route_class,
        "evidence_target": args.evidence_target,
        "acceptance_authority": "user",
        "candidate_identity": candidate_identity(project_root),
    }
    validate_slice(slice_data)
    slice_data["slice_contract_sha256"] = slice_contract_sha256(slice_data)
    slice_dir.mkdir(parents=True)
    paths = runtime_paths(slice_dir)
    state = {
        "schema_version": SCHEMA,
        "slice_id": args.slice_id,
        "state": "scoped",
        "revision": 1,
        "active_role": "scope",
        "transition_seq": 0,
        "last_event_id": None,
        "candidate_identity": slice_data["candidate_identity"],
        "slice_contract_sha256": slice_data["slice_contract_sha256"],
        "recovery": "resume",
        "lease": {"owner": None, "pid": None, "expires_at": None},
    }
    repair = {"schema_version": SCHEMA, "slice_id": args.slice_id, "dispatch_count": 0, "effective_repair_count": 0, "no_progress_count": 0, "fault_class": None, "last_player_visible_delta": None, "history": []}
    write_json(paths["slice"], slice_data)
    write_json(paths["state"], state)
    write_json(paths["manifest"], {"schema_version": SCHEMA, "slice_id": args.slice_id, "candidate_identity": slice_data["candidate_identity"], "slice_contract_sha256": slice_data["slice_contract_sha256"], "evidence": []})
    write_json(paths["repair"], repair)
    write_json(paths["transitions"], {"schema_version": SCHEMA, "transitions": {key: sorted(value) for key, value in TRANSITIONS.items()}})
    append_event(paths, state, None, "scoped", "scope", "slice contract created")
    write_json(paths["state"], state)
    print(json.dumps({"status": "created", "slice_dir": str(slice_dir), "state": state["state"]}))


def load_runtime(slice_dir: Path) -> tuple[dict[str, Path], dict[str, Any], dict[str, Any], dict[str, Any]]:
    paths = runtime_paths(slice_dir.resolve())
    slice_data = read_json(paths["slice"])
    validate_slice(slice_data)
    state = read_json(paths["state"])
    manifest = read_json(paths["manifest"])
    expected_digest = slice_contract_sha256(slice_data)
    if slice_data.get("slice_contract_sha256") != expected_digest:
        fail("identity_mismatch: slice contract digest is invalid")
    if state.get("schema_version") != SCHEMA or state.get("slice_id") != slice_data["slice_id"]:
        fail("state does not match slice contract")
    if state.get("candidate_identity") != slice_data["candidate_identity"] or state.get("slice_contract_sha256") != expected_digest:
        fail("identity_mismatch: state identity does not match slice contract")
    if manifest.get("slice_id") != slice_data["slice_id"] or manifest.get("candidate_identity") != slice_data["candidate_identity"] or manifest.get("slice_contract_sha256") != expected_digest:
        fail("identity_mismatch: manifest identity does not match slice contract")
    return paths, slice_data, state, manifest


def evidence_ids(manifest: dict[str, Any], level: str | None = None) -> set[str]:
    values = set()
    for evidence in manifest.get("evidence", []):
        if evidence.get("status") != "valid" or (level is not None and evidence.get("level") != level):
            continue
        hashes = evidence.get("artifact_hashes", [])
        if not hashes or any(not Path(item["path"]).is_file() or sha256_file(Path(item["path"])) != item["sha256"] for item in hashes):
            continue
        values.add(evidence.get("evidence_id"))
    return values


def transition(args: argparse.Namespace) -> None:
    paths, slice_data, state, manifest = load_runtime(Path(args.slice_dir))
    old, new = state["state"], args.to
    if new not in STATES or new not in TRANSITIONS.get(old, set()):
        fail(f"invalid transition {old} -> {new}")
    permitted = ROLE_FOR_TRANSITION.get((old, new), {"scope", "builder", "mechanical_qa", "evaluator", "user", "lead"})
    if args.role not in permitted:
        fail(f"role {args.role} may not perform {old} -> {new}")
    if new == "mechanically_verified" and not evidence_ids(manifest, "L2_runtime"):
        fail("mechanically_verified requires valid L2_runtime evidence")
    if new == "player_evaluated":
        evaluation_path = paths["evaluations"] / f"evaluation.{args.evaluator_run_id}.json"
        evaluation = read_json(evaluation_path)
        expected = {unit["id"] for unit in slice_data["playable_units"]}
        rows = evaluation.get("playable_unit_results")
        if evaluation.get("evaluator_run_id") != args.evaluator_run_id or not isinstance(rows, list):
            fail("player_evaluated requires evaluator_run_id and evaluation rows")
        seen = {row.get("unit_id") for row in rows if isinstance(row, dict)}
        if seen != expected or any(row.get("result") not in {"pass", "partial", "blocked", "reject"} for row in rows):
            fail("evaluation must cover every playable unit with a valid result")
        if any(row.get("result") != "pass" for row in rows):
            fail("non-pass player evaluation must transition to remediation_required or blocked")
        if not evidence_ids(manifest, "L3_player_visual"):
            fail("player_evaluated requires valid L3_player_visual evidence")
    if new == "user_acceptance_pending" and not evidence_ids(manifest, "L3_player_visual"):
        fail("user_acceptance_pending requires valid L3_player_visual evidence")
    if new == "accepted" and args.user_decision != "accepted":
        fail("accepted requires explicit --user-decision accepted")
    if old == "user_acceptance_pending" and new in {"remediation_required", "paused"} and args.user_decision != new:
        fail(f"{new} requires matching explicit user decision")
    state["state"] = new
    state["revision"] += 1
    state["active_role"] = args.role
    state["recovery"] = "user_decision" if new == "user_acceptance_pending" else "resume"
    append_event(paths, state, old, new, args.role, args.reason)
    write_json(paths["state"], state)
    print(json.dumps({"status": "transitioned", "from": old, "to": new, "revision": state["revision"]}))


def validate_l3_artifacts(evidence: dict[str, Any], state: dict[str, Any], normalized: list[dict[str, str]]) -> None:
    artifacts = {Path(item["path"]): item["sha256"] for item in normalized}
    png_paths = [path for path in artifacts if path.suffix.lower() == ".png"]
    if len(png_paths) != 1:
        fail("L3 evidence requires exactly one PNG artifact")
    png_path = png_paths[0]
    sidecar_path = png_path.with_suffix(png_path.suffix + ".json")
    if sidecar_path not in artifacts:
        fail("L3 evidence requires the PNG sidecar artifact")
    sidecar = read_json(sidecar_path)
    window = evidence.get("window_identity")
    required_window = {"pid", "hwnd", "title", "rect"}
    if not isinstance(window, dict) or required_window - set(window):
        fail("L3 evidence requires window_identity pid/hwnd/title/rect")
    if sidecar.get("schema_version") != "capture-window-v1":
        fail("L3 sidecar schema is unsupported")
    if sidecar.get("sha256") != artifacts[png_path]:
        fail("identity_mismatch: L3 PNG hash does not match sidecar")
    if sidecar.get("transaction_id") != evidence["transaction_id"]:
        fail("identity_mismatch: L3 sidecar transaction does not match evidence")
    if sidecar.get("candidate_identity") != state["candidate_identity"]:
        fail("identity_mismatch: L3 sidecar candidate does not match slice state")
    sidecar_window = {"pid": sidecar.get("pid"), "hwnd": sidecar.get("hwnd"), "title": sidecar.get("title"), "rect": sidecar.get("window_rect")}
    if sidecar_window != window:
        fail("identity_mismatch: L3 sidecar window identity does not match evidence")
    result_paths = [path for path in artifacts if path.name in {"session_result.json", "paired_result.json"}]
    if len(result_paths) != 1:
        fail("L3 evidence requires exactly one tool-owned session result")
    result = read_json(result_paths[0])
    if result.get("status") != "passed" or result.get("graceful_exit") is not True or result.get("exit_code") != 0:
        fail("L3 session result is not a successful graceful exit")
    if result.get("transaction_id") != evidence["transaction_id"] or result.get("candidate_identity") != state["candidate_identity"]:
        fail("identity_mismatch: L3 session identity does not match slice state")
    result_window = result.get("window_identity")
    if result_window != window:
        fail("identity_mismatch: L3 session window identity does not match evidence")
    capture = result.get("capture") or result.get("native_capture")
    if not isinstance(capture, dict) or capture.get("sha256") != artifacts[png_path]:
        fail("identity_mismatch: L3 session capture does not match PNG")


def record_evidence(args: argparse.Namespace) -> None:
    paths, slice_data, state, manifest = load_runtime(Path(args.slice_dir))
    evidence = read_json(Path(args.evidence_json))
    required = {"evidence_id", "transaction_id", "candidate_identity", "level", "route", "artifact_refs", "proves", "does_not_prove"}
    if required - set(evidence):
        fail("evidence missing required identity/boundary fields")
    if not isinstance(evidence["transaction_id"], str) or not evidence["transaction_id"]:
        fail("evidence transaction_id is required")
    if evidence["candidate_identity"] != state["candidate_identity"]:
        fail("identity_mismatch: evidence candidate identity does not match slice state")
    if evidence["level"] not in {"L1_static", "L2_runtime", "L3_player_visual", "L4_independent_demo"}:
        fail("invalid evidence level")
    if evidence["evidence_id"] in {item.get("evidence_id") for item in manifest.get("evidence", [])}:
        fail("evidence_id already exists; append a new lineage record instead")
    refs = evidence["artifact_refs"]
    if not isinstance(refs, list) or not refs:
        fail("artifact_refs must be non-empty")
    normalized = []
    declared_transactions: set[str] = set()
    declared_candidate_shas: set[str] = set()
    for raw in refs:
        artifact = Path(raw).resolve()
        if not artifact.is_file():
            fail(f"artifact missing: {artifact}")
        normalized.append({"path": str(artifact), "sha256": hashlib.sha256(artifact.read_bytes()).hexdigest()})
        if artifact.suffix.lower() == ".json":
            try:
                artifact_data = read_json(artifact)
            except ValueError:
                artifact_data = {}
            transaction = artifact_data.get("transaction_id")
            if isinstance(transaction, str) and transaction:
                declared_transactions.add(transaction)
            candidate_sha = artifact_data.get("candidate_working_tree_sha") or artifact_data.get("candidate_sha")
            if isinstance(candidate_sha, str) and candidate_sha:
                declared_candidate_shas.add(candidate_sha)
    if declared_transactions and declared_transactions != {evidence["transaction_id"]}:
        fail("identity_mismatch: artifact transaction_id does not match evidence descriptor")
    expected_working_tree_sha = state["candidate_identity"].get("working_tree_sha256")
    if declared_candidate_shas and declared_candidate_shas != {expected_working_tree_sha}:
        fail("identity_mismatch: artifact candidate SHA does not match slice state")
    if evidence["level"] == "L3_player_visual":
        validate_l3_artifacts(evidence, state, normalized)
    evidence["artifact_hashes"] = normalized
    evidence["candidate_identity"] = state["candidate_identity"]
    evidence["status"] = "valid"
    evidence["recorded_at"] = now()
    manifest.setdefault("evidence", []).append(evidence)
    write_json(paths["manifest"], manifest)
    append_event(paths, state, state["state"], state["state"], args.role, f"recorded evidence {evidence['evidence_id']}", [evidence["evidence_id"]])
    write_json(paths["state"], state)
    print(json.dumps({"status": "recorded", "evidence_id": evidence["evidence_id"], "level": evidence["level"]}))


def record_evaluation(args: argparse.Namespace) -> None:
    paths, slice_data, state, manifest = load_runtime(Path(args.slice_dir))
    evaluation = read_json(Path(args.evaluation_json))
    if not isinstance(evaluation.get("evaluator_run_id"), str) or not evaluation["evaluator_run_id"]:
        fail("evaluation requires evaluator_run_id")
    if not isinstance(evaluation.get("transaction_id"), str) or not evaluation["transaction_id"]:
        fail("evaluation requires transaction_id")
    if evaluation.get("mutated_production") is not False:
        fail("evaluator must declare mutated_production: false")
    if evaluation.get("candidate_identity") != state["candidate_identity"]:
        fail("evaluation candidate identity does not match state")
    expected = {unit["id"] for unit in slice_data["playable_units"]}
    rows = evaluation.get("playable_unit_results")
    if not isinstance(rows, list) or {row.get("unit_id") for row in rows if isinstance(row, dict)} != expected:
        fail("evaluation must contain one result for every playable unit")
    valid_evidence = {item.get("evidence_id"): item for item in manifest.get("evidence", []) if item.get("status") == "valid"}
    for row in rows:
        if row.get("result") not in {"pass", "partial", "blocked", "reject"} or not row.get("evidence_ids"):
            fail("each evaluation row requires result and evidence_ids")
        for evidence_id in row["evidence_ids"]:
            evidence = valid_evidence.get(evidence_id)
            if evidence is None:
                fail(f"evaluation references unknown or invalid evidence: {evidence_id}")
            if evidence.get("transaction_id") != evaluation["transaction_id"]:
                fail(f"evaluation evidence transaction mismatch: {evidence_id}")
            if evidence.get("candidate_identity") != state["candidate_identity"]:
                fail(f"evaluation evidence candidate identity mismatch: {evidence_id}")
    paths["evaluations"].mkdir(parents=True, exist_ok=True)
    evaluation_path = paths["evaluations"] / f"evaluation.{evaluation['evaluator_run_id']}.json"
    if evaluation_path.exists():
        fail("evaluator_run_id already exists; create a new run instead of overwriting evidence")
    write_json(evaluation_path, evaluation)
    append_event(paths, state, state["state"], state["state"], "evaluator", f"recorded evaluation {evaluation['evaluator_run_id']}", [str(evaluation_path)])
    write_json(paths["state"], state)
    print(json.dumps({"status": "evaluation_recorded", "run_id": evaluation["evaluator_run_id"]}))


def recover(args: argparse.Namespace) -> None:
    paths, _, state, _ = load_runtime(Path(args.slice_dir))
    repair = read_json(paths["repair"])
    kind = args.kind
    if kind not in {"dispatch", "effective_repair", "no_progress"}:
        fail("invalid recovery kind")
    repair[f"{kind}_count" if kind != "effective_repair" else "effective_repair_count"] += 1
    if kind == "no_progress" and repair["no_progress_count"] >= 3:
        if state["state"] not in {"scoped", "building", "mechanically_verified", "player_evaluated", "remediation_required", "blocked"}:
            fail("no_progress cannot pause a terminal or user-decision state")
        state["state"] = "paused"
        state["recovery"] = "user_decision"
    repair["fault_class"] = args.fault_class
    repair["last_player_visible_delta"] = args.player_visible_delta
    repair["history"].append({"ts_utc": now(), "kind": kind, "fault_class": args.fault_class, "fingerprint": args.fingerprint, "player_visible_delta": args.player_visible_delta})
    write_json(paths["repair"], repair)
    append_event(paths, state, state["state"], state["state"], args.role, f"repair accounting {kind}")
    write_json(paths["state"], state)
    print(json.dumps({"status": "recovery_recorded", "repair": repair, "state": state["state"]}))


def status(args: argparse.Namespace) -> None:
    paths, slice_data, state, manifest = load_runtime(Path(args.slice_dir))
    repair = read_json(paths["repair"])
    print(json.dumps({"slice": slice_data, "state": state, "evidence_count": len(manifest.get("evidence", [])), "repair": repair}, indent=2, ensure_ascii=False))


def parser() -> argparse.ArgumentParser:
    root = argparse.ArgumentParser()
    sub = root.add_subparsers(dest="command", required=True)
    start_parser = sub.add_parser("start")
    start_parser.add_argument("--slice-dir", required=True)
    start_parser.add_argument("--slice-id", required=True)
    start_parser.add_argument("--player-promise", required=True)
    start_parser.add_argument("--units-json", required=True)
    start_parser.add_argument("--project-root", required=True)
    start_parser.add_argument("--route-class", default="non_mutating_validation")
    start_parser.add_argument("--evidence-target", default="L3_player_visual")
    start_parser.set_defaults(func=start)
    transition_parser = sub.add_parser("transition")
    transition_parser.add_argument("--slice-dir", required=True)
    transition_parser.add_argument("--to", required=True)
    transition_parser.add_argument("--role", required=True)
    transition_parser.add_argument("--reason", required=True)
    transition_parser.add_argument("--evaluator-run-id")
    transition_parser.add_argument("--user-decision")
    transition_parser.set_defaults(func=transition)
    evidence_parser = sub.add_parser("record-evidence")
    evidence_parser.add_argument("--slice-dir", required=True)
    evidence_parser.add_argument("--evidence-json", required=True)
    evidence_parser.add_argument("--role", required=True)
    evidence_parser.set_defaults(func=record_evidence)
    evaluation_parser = sub.add_parser("record-evaluation")
    evaluation_parser.add_argument("--slice-dir", required=True)
    evaluation_parser.add_argument("--evaluation-json", required=True)
    evaluation_parser.set_defaults(func=record_evaluation)
    recovery_parser = sub.add_parser("recover")
    recovery_parser.add_argument("--slice-dir", required=True)
    recovery_parser.add_argument("--kind", required=True)
    recovery_parser.add_argument("--fault-class", required=True)
    recovery_parser.add_argument("--fingerprint", required=True)
    recovery_parser.add_argument("--player-visible-delta", required=True)
    recovery_parser.add_argument("--role", required=True)
    recovery_parser.set_defaults(func=recover)
    status_parser = sub.add_parser("status")
    status_parser.add_argument("--slice-dir", required=True)
    status_parser.set_defaults(func=status)
    return root


def main() -> int:
    try:
        args = parser().parse_args()
        args.func(args)
        return 0
    except (ValueError, OSError, subprocess.SubprocessError) as error:
        print(json.dumps({"status": "blocked", "error": str(error)}), file=sys.stderr)
        return 2

if __name__ == "__main__":
    raise SystemExit(main())
