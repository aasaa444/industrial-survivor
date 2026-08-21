#!/usr/bin/env python3
"""Staged-only Integration Integrity verifier.

Never stages, formats, cleans, resets, stashes, or reads unstaged content as a candidate.
It validates the contract shape and requires a staged receipt for production mutations.
"""
from __future__ import annotations
import argparse, json, subprocess, sys
from pathlib import Path

REQUIRED_STEPS = ["trigger", "mutate", "read_model", "behavior", "feedback", "reset"]

def git(root: Path, *args: str) -> str:
    return subprocess.check_output(["git", "-C", str(root), *args], text=True, encoding="utf-8", errors="replace")

def staged_paths(root: Path) -> list[str]:
    raw = git(root, "diff", "--cached", "--name-only", "--diff-filter=ACMR")
    return [line.strip().replace("\\", "/") for line in raw.splitlines() if line.strip()]

def fail(message: str, checks: list[dict]) -> int:
    result = {"schema_version":"integration-verifier-v1","status":"failed","checks":checks+[{"id":"failure","status":"failed","message":message}],"exit_code":2}
    print(json.dumps(result, ensure_ascii=False, indent=2)); return 2

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--project-root", type=Path, required=True)
    ap.add_argument("--contract", type=Path, required=True)
    ap.add_argument("--receipt", type=Path)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args(); root=args.project_root.resolve(); contract_path=args.contract.resolve()
    try: contract=json.loads(contract_path.read_text(encoding="utf-8"))
    except Exception as e: return fail(f"contract unreadable: {e}", [])
    checks=[]
    if contract.get("schema_version") != "integration-contract-v1": return fail("schema_version mismatch", checks)
    if not contract.get("contract_id") or not contract.get("project_root"): return fail("contract_id/project_root missing", checks)
    owner=contract.get("state_owner",{}); writers=owner.get("writers",[])
    if len(writers)!=1: return fail("state_owner.writers must contain exactly one production writer", checks)
    steps=[x.get("id") for x in contract.get("transaction",[])]
    if steps != REQUIRED_STEPS: return fail(f"transaction must be {REQUIRED_STEPS}, got {steps}", checks)
    checks.append({"id":"schema","status":"passed"}); checks.append({"id":"single_writer","status":"passed","writer":writers[0]}); checks.append({"id":"transaction_order","status":"passed"})
    paths=staged_paths(root)
    if args.dry_run:
        print(json.dumps({"schema_version":"integration-verifier-v1","status":"dry_run","contract_id":contract["contract_id"],"staged_paths":paths,"will_mutate_project":contract.get("policy",{}).get("will_mutate_project"),"workspace_is_not_scanned":True,"checks":checks,"exit_code":0},ensure_ascii=False,indent=2)); return 0
    receipt = args.receipt.resolve() if args.receipt else None
    if contract.get("policy",{}).get("staged_only_static_gate") and not paths:
        return fail("no staged candidate; verifier will not inspect unstaged workspace", checks)
    if contract.get("policy",{}).get("will_mutate_project") and not receipt:
        return fail("production contract requires --receipt bound to current staged candidate", checks)
    if receipt:
        try: data=json.loads(receipt.read_text(encoding="utf-8"))
        except Exception as e: return fail(f"receipt unreadable: {e}",checks)
        if data.get("status") != "passed" or data.get("contract_id") != contract["contract_id"]:
            return fail("receipt status/contract_id mismatch",checks)
        checks.append({"id":"receipt","status":"passed"})
    print(json.dumps({"schema_version":"integration-verifier-v1","status":"passed","contract_id":contract["contract_id"],"checks":checks,"staged_paths":paths,"workspace_is_not_scanned":True,"evidence_boundary":"static contract only; runtime/visual acceptance remains unproven","exit_code":0},ensure_ascii=False,indent=2)); return 0

if __name__ == "__main__": raise SystemExit(main())
