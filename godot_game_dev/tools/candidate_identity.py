#!/usr/bin/env python3
"""Stable dirty-worktree identity for New_Game evidence binding."""
from __future__ import annotations

import hashlib
import os
import subprocess
from pathlib import Path


def _run(root: Path, *args: str) -> bytes:
    return subprocess.check_output(["git", *args], cwd=root, stderr=subprocess.DEVNULL)


def _hash_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _is_runtime_output(relative: str) -> bool:
    normalized = relative.replace("\\", "/")
    return normalized.startswith(".zcode/") or normalized.startswith("qa/evidence/") or normalized.startswith("tools/__pycache__/")


def calculate(project_root: Path) -> dict[str, object]:
    root = project_root.resolve()
    head = _run(root, "rev-parse", "HEAD").decode().strip()
    tracked = _run(root, "diff", "--binary", "HEAD") + b"\0--staged--\0" + _run(root, "diff", "--cached", "--binary")
    untracked_rows: list[bytes] = []
    untracked_digest = hashlib.sha256()
    for raw in _run(root, "ls-files", "--others", "--exclude-standard", "-z").split(b"\0"):
        if not raw:
            continue
        relative = raw.decode("utf-8", errors="surrogateescape")
        if _is_runtime_output(relative):
            continue
        candidate = root / relative
        if candidate.is_file() and not candidate.is_symlink():
            content = _hash_file(candidate)
            row = f"F\0{relative}\0{content}\0".encode("utf-8", errors="surrogateescape")
        elif candidate.is_symlink():
            row = f"L\0{relative}\0{os.readlink(candidate)}\0".encode("utf-8", errors="surrogateescape")
        else:
            continue
        untracked_rows.append(row)
        untracked_digest.update(row)
    status = _run(root, "status", "--porcelain=v1").decode("utf-8", errors="replace").splitlines()
    digest = hashlib.sha256()
    digest.update(b"git-worktree-v2\0")
    digest.update(head.encode())
    digest.update(b"\0--tracked--\0")
    digest.update(tracked)
    digest.update(b"\0--untracked--\0")
    for row in sorted(untracked_rows):
        digest.update(row)
    return {
        "identity_version": "git-worktree-v2",
        "git_head": head,
        "dirty": bool(status),
        "working_tree_sha256": digest.hexdigest(),
        "untracked_content_sha256": untracked_digest.hexdigest(),
        "status_porcelain": status,
    }
