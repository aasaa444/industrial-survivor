#!/usr/bin/env python3
"""Report import -> loader -> parse layers for one Godot resource."""
from __future__ import annotations
import argparse
import json
from pathlib import Path

from background_process import run


def execute(command: list[str], cwd: Path, log_dir: Path, label: str) -> dict:
    record = run("headless_godot", command, cwd, log_dir, label, quiet_host=True, timeout=120)
    stdout = Path(record["stdout"]).read_text(encoding="utf-8", errors="replace")[-2000:]
    stderr = Path(record["stderr"]).read_text(encoding="utf-8", errors="replace")[-2000:]
    return {
        "exit": record["exit_code"],
        "status": record["status"],
        "stdout": stdout,
        "stderr": stderr,
        "session_record": str(log_dir / f"{record['session_id']}.json"),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project-root", type=Path, default=Path.cwd())
    parser.add_argument("--resource", required=True)
    parser.add_argument("--godot", type=Path, required=True)
    parser.add_argument("--log-dir", type=Path)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    root = args.project_root.resolve()
    resource = root / args.resource
    log_dir = (args.log_dir or root / "qa" / "evidence" / "background-resource-layers").resolve()
    result = {
        "project_root": str(root),
        "resource": args.resource,
        "resource_exists": resource.exists(),
        "import_sidecar_exists": Path(str(resource) + ".import").exists(),
        "layers": {},
        "evidence_boundary": "import/parse only; does not prove active scene loading, runtime interaction, visual pixels, or player experience",
    }
    if args.dry_run:
        print(json.dumps(result, indent=2))
        return 0
    result["layers"]["headless_import"] = execute([str(args.godot), "--headless", "--import", "--path", str(root)], root, log_dir, "resource-import")
    result["layers"]["parse"] = execute([str(args.godot), "--headless", "--path", str(root), "--quit-after", "3"], root, log_dir, "resource-parse")
    parse_text = result["layers"]["parse"]["stdout"] + "\n" + result["layers"]["parse"]["stderr"]
    result["parse_ok"] = "Parse Error" not in parse_text and "SCRIPT ERROR" not in parse_text and result["layers"]["parse"]["status"] == "passed"
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result["resource_exists"] and result["parse_ok"] else 2


if __name__ == "__main__":
    raise SystemExit(main())
