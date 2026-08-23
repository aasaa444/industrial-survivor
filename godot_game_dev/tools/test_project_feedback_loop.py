import tempfile
import unittest
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
import sys
sys.path.insert(0, str(TOOLS))
import background_process
import project_feedback_loop


class FeedbackLoopTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        (self.root / "project.godot").write_text(
            "[application]\nrun/main_scene=\"res://scenes/main.tscn\"\n",
            encoding="utf-8",
        )
        (self.root / "scenes").mkdir()
        (self.root / "scenes" / "main.tscn").write_text("[gd_scene format=3]\n", encoding="utf-8")
        self.godot = self.root / "godot.exe"
        self.godot.write_text("fake", encoding="utf-8")
        self.logs = self.root / "logs"
        self.calls = []

    def tearDown(self):
        self.temp.cleanup()

    def fake_runner(self, statuses):
        def run(profile, argv, cwd, log_dir, label, quiet_host, timeout):
            self.calls.append((label, list(argv)))
            log_dir.mkdir(parents=True, exist_ok=True)
            session = f"BG-{len(self.calls):03d}"
            stdout = log_dir / f"{session}.stdout.log"
            stderr = log_dir / f"{session}.stderr.log"
            stdout.write_text(statuses.get(label, {}).get("stdout", ""), encoding="utf-8")
            stderr.write_text(statuses.get(label, {}).get("stderr", ""), encoding="utf-8")
            child = statuses.get(label, {}).get("child_exit_code", 0)
            status = statuses.get(label, {}).get("status", "passed")
            record = {
                "schema_version": "background-process-v2",
                "session_id": session,
                "status": status,
                "child_exit_code": child,
                "launcher_exit_code": statuses.get(label, {}).get("launcher_exit_code", child if status != "blocked" else background_process.TIMEOUT_EXIT_CODE),
                "result_source": statuses.get(label, {}).get("result_source", "child" if status != "blocked" else "timeout"),
                "stdout": str(stdout),
                "stderr": str(stderr),
            }
            (log_dir / f"{session}.json").write_text("{}", encoding="utf-8")
            return record
        return run

    def run_loop(self, statuses, target=None):
        return project_feedback_loop.run_feedback_loop(
            self.root,
            self.godot,
            self.logs,
            target_argv=target,
            runner=self.fake_runner(statuses),
            candidate_identity={"identity_version": "git-worktree-v2", "working_tree_sha256": "candidate"},
        )

    def test_launcher_success_does_not_hide_compile_failure(self):
        receipt = self.run_loop({
            "project_compile": {"status": "failed", "child_exit_code": 2, "launcher_exit_code": 2, "stdout": "", "stderr": "Parse Error"},
        })
        self.assertEqual(receipt["launcher"]["status"], "failed")
        self.assertEqual(receipt["godot"]["project_compile"], "failed")
        self.assertEqual(receipt["final"]["status"], "blocked")
        self.assertEqual([label for label, _ in self.calls], ["project_compile"])

    def test_boot_failure_stops_before_target_tests(self):
        receipt = self.run_loop({
            "project_compile": {"status": "passed", "child_exit_code": 0},
            "active_scene_boot": {"status": "failed", "child_exit_code": 1, "launcher_exit_code": 1, "stderr": "SCRIPT ERROR"},
        }, target=[sys.executable, "-c", "raise SystemExit(0)"])
        self.assertEqual(receipt["godot"]["project_compile"], "passed")
        self.assertEqual(receipt["godot"]["active_scene_boot"], "failed")
        self.assertEqual(receipt["mechanical"]["target_tests"], "not_run")
        self.assertEqual(receipt["final"]["status"], "blocked")
        self.assertEqual([label for label, _ in self.calls], ["project_compile", "active_scene_boot"])

    def test_target_failure_blocks_mechanical_progress(self):
        receipt = self.run_loop({
            "project_compile": {"status": "passed", "child_exit_code": 0},
            "active_scene_boot": {"status": "passed", "child_exit_code": 0},
            "target-tests": {"status": "failed", "child_exit_code": 7, "launcher_exit_code": 7},
        }, target=[sys.executable, "-c", "raise SystemExit(7)"])
        self.assertEqual(receipt["mechanical"]["target_tests"], "failed")
        self.assertEqual(receipt["final"]["status"], "blocked")
        self.assertEqual(receipt["launcher"]["exit_code"], 7)

    def test_timeout_is_blocked_and_keeps_timeout_source(self):
        receipt = self.run_loop({
            "project_compile": {"status": "blocked", "child_exit_code": None, "launcher_exit_code": 124, "result_source": "timeout"},
        })
        self.assertEqual(receipt["final"]["status"], "blocked")
        self.assertEqual(receipt["launcher"]["exit_code"], 124)
        self.assertEqual(receipt["launcher"]["result_source"], "timeout")

    def test_success_without_target_tests_does_not_claim_target_passed(self):
        receipt = self.run_loop({
            "project_compile": {"status": "passed", "child_exit_code": 0},
            "active_scene_boot": {"status": "passed", "child_exit_code": 0},
        })
        self.assertEqual(receipt["final"]["status"], "passed")
        self.assertEqual(receipt["mechanical"]["target_tests"], "not_run")
        self.assertNotEqual(receipt["mechanical"]["target_tests"], "passed")

    def test_project_file_missing_is_launcher_blocked(self):
        self.godot.unlink()
        receipt = project_feedback_loop.run_feedback_loop(self.root, self.godot, self.logs)
        self.assertEqual(receipt["final"]["status"], "blocked")
        self.assertEqual(receipt["launcher"]["exit_code"], background_process.LAUNCHER_ERROR_EXIT_CODE)


if __name__ == "__main__":
    unittest.main()
