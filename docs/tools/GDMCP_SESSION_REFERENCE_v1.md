# GDMCP Session and Resource Layer Reference v1

## Session / Port Inspection

Use `tools/godot_session_lease.py` to inspect Godot processes and 9080/31002 ownership before runtime work.

```powershell
python tools/godot_session_lease.py --project-root . --dry-run
python tools/godot_session_lease.py --project-root . --acquire <CALLER_OWNED_PID>
```

It never starts, kills, or changes a process/port. External PID ownership is `blocked` unless the user authorizes that PID. Lease files are observation metadata only; they do not prove GDMCP connectivity or runtime state.

## Resource Layers

Use `tools/verify_resource_layers.py` to keep these facts separate:

```text
import completion != loader probe != parse != scene load != runtime interaction != visual pixels
```

```powershell
python tools/verify_resource_layers.py `
  --project-root . `
  --resource assets/player_idle_48.png `
  --godot <ABSOLUTE_GODOT_EXE>
```

The tool reports resource/sidecar existence, headless import exit, parse exit, and `parse_ok`. It exits 2 if the resource is missing or parse is invalid. It does not prove the resource is loaded by the active scene; Gameplay Engineer consumer smoke remains required.

## Current Known Limitation

When the user-owned editor already owns MCP port `9080`, a separate headless import process can emit a plugin port-conflict warning and exit-leak noise even if import/parse complete. This is **not** auto-repaired by this tool: the session/port inspector reports the editor owner, and the caller must treat the import layer as `completed with session limitation`, not as a clean runtime pass. The tool never closes the editor or changes the port.

## Safety

- Use project-local GDMCP launcher first for project-aware actions.
- Do not PATH-fallback, mass-kill Godot, or silently change ports.
- Tool-created runtime process trees require explicit lease ownership before release.
- Revalidate after Godot, GDMCP, Windows, or port policy changes.
