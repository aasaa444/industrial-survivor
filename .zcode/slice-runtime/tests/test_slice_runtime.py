#!/usr/bin/env python3
import json
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RUNTIME = ROOT / "tools" / "slice_runtime.py"
PROJECT = Path("D:/Game/New_Game/godot_game_dev")


class SliceRuntimeTest(unittest.TestCase):
    def setUp(self):
        self.temp = Path(tempfile.mkdtemp(prefix="slice-runtime-test-"))
        self.slice_dir = self.temp / "slice"
        self.units = self.temp / "units.json"
        self.units.write_text(json.dumps([{
            "id": "PU-1", "action": "launch", "state_owner": "game", "effect": "frame", "feedback": "visible HUD", "pressure": "threat visible", "terminal_or_reset": "restart"
        }]), encoding="utf-8")
        self.invoke("start", "--slice-dir", str(self.slice_dir), "--slice-id", "TEST-SLICE", "--player-promise", "validate runtime state", "--units-json", str(self.units), "--project-root", str(PROJECT))

    def tearDown(self):
        shutil.rmtree(self.temp, ignore_errors=True)

    def invoke(self, *args, expect=0):
        result = subprocess.run(["python", str(RUNTIME), *args], text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        self.assertEqual(result.returncode, expect, result.stderr)
        return result

    def evidence_file(self, name="artifact.txt"):
        file = self.temp / name
        file.write_text("artifact", encoding="utf-8")
        return file

    def record(self, level, evidence_id, window=False):
        artifact = self.evidence_file(f"{evidence_id}.png" if window else f"{evidence_id}.txt")
        payload = {
            "evidence_id": evidence_id,
            "transaction_id": "TX-1",
            "candidate_identity": json.loads((self.slice_dir / "state.json").read_text())["candidate_identity"],
            "level": level,
            "route": "test",
            "artifact_refs": [str(artifact)],
            "proves": "test boundary",
            "does_not_prove": "user acceptance",
        }
        if window:
            sidecar = artifact.with_suffix(artifact.suffix + ".json")
            session = self.temp / "session_result.json"
            sidecar.write_text(json.dumps({
                "schema_version": "capture-window-v1", "pid": 1, "hwnd": 2, "title": "Game", "window_rect": [1, 1, 100, 100],
                "sha256": __import__("hashlib").sha256(artifact.read_bytes()).hexdigest(), "transaction_id": "TX-1", "candidate_identity": payload["candidate_identity"],
            }), encoding="utf-8")
            session.write_text(json.dumps({
                "status": "passed", "graceful_exit": True, "exit_code": 0, "transaction_id": "TX-1", "candidate_identity": payload["candidate_identity"],
                "window_identity": {"pid": 1, "hwnd": 2, "title": "Game", "rect": [1, 1, 100, 100]}, "capture": {"sha256": __import__("hashlib").sha256(artifact.read_bytes()).hexdigest()},
            }), encoding="utf-8")
            payload["window_identity"] = {"pid": 1, "hwnd": 2, "title": "Game", "rect": [1, 1, 100, 100]}
            payload["artifact_refs"] += [str(sidecar), str(session)]
        path = self.temp / f"{evidence_id}.json"
        path.write_text(json.dumps(payload), encoding="utf-8")
        self.invoke("record-evidence", "--slice-dir", str(self.slice_dir), "--evidence-json", str(path), "--role", "mechanical_qa")

    def test_rejects_state_identity_drift(self):
        state_path = self.slice_dir / "state.json"
        state = json.loads(state_path.read_text())
        state["candidate_identity"]["working_tree_sha256"] = "tampered"
        state_path.write_text(json.dumps(state), encoding="utf-8")
        result = self.invoke("status", "--slice-dir", str(self.slice_dir), expect=2)
        self.assertIn("identity_mismatch", result.stderr)

    def test_rejects_forged_l3_without_sidecar_and_session(self):
        artifact = self.evidence_file("forged.png")
        descriptor = {
            "evidence_id": "E-FORGED-L3", "transaction_id": "TX-1",
            "candidate_identity": json.loads((self.slice_dir / "state.json").read_text())["candidate_identity"],
            "level": "L3_player_visual", "route": "forged", "artifact_refs": [str(artifact)],
            "window_identity": {"pid": 1, "hwnd": 2, "title": "Game", "rect": [1, 1, 100, 100]},
            "proves": "forged", "does_not_prove": "acceptance",
        }
        path = self.temp / "forged-l3.json"
        path.write_text(json.dumps(descriptor), encoding="utf-8")
        result = self.invoke("record-evidence", "--slice-dir", str(self.slice_dir), "--evidence-json", str(path), "--role", "mechanical_qa", expect=2)
        self.assertIn("L3 evidence requires", result.stderr)

    def test_rejects_evidence_candidate_mismatch(self):
        artifact = self.temp / "mismatch.json"
        artifact.write_text(json.dumps({
            "transaction_id": "TX-1",
            "candidate_sha": "wrong-candidate",
            "state": "pulse_flash_active",
        }), encoding="utf-8")
        descriptor = {
            "evidence_id": "E-MISMATCH",
            "transaction_id": "TX-1",
            "candidate_identity": json.loads((self.slice_dir / "state.json").read_text())["candidate_identity"],
            "level": "L2_runtime",
            "route": "test",
            "artifact_refs": [str(artifact)],
            "proves": "test",
            "does_not_prove": "acceptance",
        }
        descriptor_path = self.temp / "mismatch-descriptor.json"
        descriptor_path.write_text(json.dumps(descriptor), encoding="utf-8")
        result = self.invoke("record-evidence", "--slice-dir", str(self.slice_dir), "--evidence-json", str(descriptor_path), "--role", "mechanical_qa", expect=2)
        self.assertIn("identity_mismatch", result.stderr)

    def test_rejects_accepted_without_user_decision(self):
        result = self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "accepted", "--role", "user", "--reason", "skip", expect=2)
        self.assertIn("invalid transition", result.stderr)

    def test_rejects_mechanical_transition_without_l2(self):
        self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "building", "--role", "builder", "--reason", "start")
        result = self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "mechanically_verified", "--role", "mechanical_qa", "--reason", "none", expect=2)
        self.assertIn("L2_runtime", result.stderr)

    def test_requires_l3_and_complete_evaluation(self):
        self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "building", "--role", "builder", "--reason", "start")
        self.record("L2_runtime", "E-L2")
        self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "mechanically_verified", "--role", "mechanical_qa", "--reason", "passed")
        evaluation = {
            "evaluator_run_id": "EVAL-1",
            "transaction_id": "TX-1",
            "mutated_production": False,
            "candidate_identity": json.loads((self.slice_dir / "state.json").read_text())["candidate_identity"],
            "playable_unit_results": [{"unit_id": "PU-1", "result": "pass", "evidence_ids": ["E-L2"]}],
        }
        eval_path = self.temp / "evaluation.json"
        eval_path.write_text(json.dumps(evaluation), encoding="utf-8")
        self.invoke("record-evaluation", "--slice-dir", str(self.slice_dir), "--evaluation-json", str(eval_path))
        result = self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "player_evaluated", "--role", "evaluator", "--reason", "missing L3", "--evaluator-run-id", "EVAL-1", expect=2)
        self.assertIn("L3_player_visual", result.stderr)
        self.record("L3_player_visual", "E-L3", window=True)
        (self.temp / "E-L3.png").write_bytes(b"tampered")
        result = self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "player_evaluated", "--role", "evaluator", "--reason", "tampered", "--evaluator-run-id", "EVAL-1", expect=2)
        self.assertIn("L3_player_visual", result.stderr)

    def test_allows_remediation_recovery(self):
        self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "building", "--role", "builder", "--reason", "start")
        self.record("L2_runtime", "E-L2")
        self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "mechanically_verified", "--role", "mechanical_qa", "--reason", "passed")
        self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "remediation_required", "--role", "scope", "--reason", "defect")
        self.invoke("transition", "--slice-dir", str(self.slice_dir), "--to", "building", "--role", "builder", "--reason", "repair")

    def test_rejects_duplicate_evaluator_run_id(self):
        self.record("L2_runtime", "E-DUPLICATE")
        evaluation = {
            "evaluator_run_id": "EVAL-DUPLICATE",
            "transaction_id": "TX-1",
            "mutated_production": False,
            "candidate_identity": json.loads((self.slice_dir / "state.json").read_text())["candidate_identity"],
            "playable_unit_results": [{"unit_id": "PU-1", "result": "pass", "evidence_ids": ["E-DUPLICATE"]}],
        }
        path = self.temp / "evaluation-duplicate.json"
        path.write_text(json.dumps(evaluation), encoding="utf-8")
        self.invoke("record-evaluation", "--slice-dir", str(self.slice_dir), "--evaluation-json", str(path))
        result = self.invoke("record-evaluation", "--slice-dir", str(self.slice_dir), "--evaluation-json", str(path), expect=2)
        self.assertIn("already exists", result.stderr)

    def test_rejects_evaluator_production_mutation_claim(self):
        evaluation = {
            "evaluator_run_id": "EVAL-BAD",
            "transaction_id": "TX-1",
            "mutated_production": True,
            "candidate_identity": json.loads((self.slice_dir / "state.json").read_text())["candidate_identity"],
            "playable_unit_results": [{"unit_id": "PU-1", "result": "pass", "evidence_ids": ["x"]}],
        }
        path = self.temp / "evaluation-bad.json"
        path.write_text(json.dumps(evaluation), encoding="utf-8")
        result = self.invoke("record-evaluation", "--slice-dir", str(self.slice_dir), "--evaluation-json", str(path), expect=2)
        self.assertIn("mutated_production", result.stderr)


if __name__ == "__main__":
    unittest.main()
