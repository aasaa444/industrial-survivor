#!/usr/bin/env python3
"""Read-only Godot session/port health inspection and lease registry.

This tool never terminates processes. It only records a lease for a caller-owned PID
and reports port ownership; external ports/PIDs are blocked, not killed.
"""
from __future__ import annotations
import argparse, json, socket, subprocess, sys
from datetime import datetime, timezone
from pathlib import Path

DEFAULT_PORTS = (9080, 31002)

def process_rows() -> list[dict[str, object]]:
    cmd = ["powershell", "-NoProfile", "-Command", "Get-CimInstance Win32_Process | Where-Object {$_.Name -like 'Godot*'} | ForEach-Object { [pscustomobject]@{pid=$_.ProcessId;name=$_.Name;cmd=$_.CommandLine} } | ConvertTo-Json -Compress"]
    out = subprocess.check_output(cmd, text=True, encoding="utf-8", errors="replace").strip()
    if not out: return []
    data = json.loads(out); return data if isinstance(data, list) else [data]

def port_owner(port: int) -> str:
    try:
        out = subprocess.check_output(["powershell", "-NoProfile", "-Command", f"Get-NetTCPConnection -LocalPort {port} -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty OwningProcess"], text=True, encoding="utf-8", errors="replace").strip()
        return out or "free"
    except Exception: return "unknown"

def main() -> int:
    p = argparse.ArgumentParser(description="Inspect Godot sessions and optionally register a caller-owned lease.")
    p.add_argument("--project-root", type=Path, default=Path.cwd())
    p.add_argument("--ports", default="9080,31002")
    p.add_argument("--dry-run", action="store_true")
    p.add_argument("--acquire", type=int, metavar="PID", help="Register only this caller-owned PID; does not start it.")
    p.add_argument("--lease", type=Path, default=Path("qa/evidence/session-leases/current.json"))
    a = p.parse_args(); root=a.project_root.resolve(); ports=tuple(int(x) for x in a.ports.split(",") if x.strip())
    state={"captured_at_utc":datetime.now(timezone.utc).isoformat(),"project_root":str(root),"ports":{str(x):port_owner(x) for x in ports},"godot_processes":process_rows(),"mutation":False}
    if a.dry_run:
        state["policy"]="inspect only; no process termination, no port change, no project mutation"; print(json.dumps(state,ensure_ascii=False,indent=2)); return 0
    if a.acquire:
        matching=[x for x in state["godot_processes"] if int(x.get("pid",-1))==a.acquire]
        if not matching:
            print("lease rejected: PID is not a visible Godot process",file=sys.stderr); return 2
        lease={**state,"lease_owner_pid":a.acquire,"lease_kind":"caller_owned_observation_only","ttl_note":"no automatic termination; caller releases explicitly"}
        target=a.lease if a.lease.is_absolute() else root/a.lease; target.parent.mkdir(parents=True,exist_ok=True); target.write_text(json.dumps(lease,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
        print(json.dumps({"lease":str(target.resolve()),"pid":a.acquire,"ports":state["ports"]},ensure_ascii=False)); return 0
    print(json.dumps(state,ensure_ascii=False,indent=2)); return 0
if __name__=="__main__": raise SystemExit(main())
