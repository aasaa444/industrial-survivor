import json
import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
sys.path.insert(0, str(TOOLS))
import background_process


class BackgroundProcessTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        (self.root / ".gdmcp" / "bin").mkdir(parents=True)
        self.gdmcp = self.root / ".gdmcp" / "bin" / "gdmcp.exe"
        self.gdmcp.write_text("placeholder", encoding="utf-8")

    def tearDown(self):
        self.temp.cleanup()

    def test_redacts_separate_equals_and_preserves_ordinary_paths(self):
        redacted = background_process.redact_argv([
            "tool", "--TOKEN", "secret-one", "--authorization=secret-two",
            "--api-key", "secret-three", "/path/token-cache/file", "plain",
        ])
        self.assertEqual(redacted, [
            "tool", "--TOKEN", "<redacted>", "--authorization=<redacted>",
            "--api-key", "<redacted>", "/path/token-cache/file", "plain",
        ])
        self.assertNotIn("secret-one", redacted)
        self.assertNotIn("secret-two", redacted)
        self.assertNotIn("secret-three", redacted)

    def test_gdmcp_requires_project_local_binary(self):
        with self.assertRaises(ValueError):
            background_process.validate("gdmcp", ["gdmcp", "doctor"], self.root)
        background_process.validate("gdmcp", [str(self.gdmcp), "doctor"], self.root)

    def test_headless_profile_requires_headless_argument(self):
        with self.assertRaises(ValueError):
            background_process.validate("headless_godot", [sys.executable, "-c", "print(1)"], self.root)
        background_process.validate("headless_godot", [sys.executable, "--headless"], self.root)

    def test_rejects_real_input_and_capture_arguments(self):
        for forbidden in ("--allow-real-input", "--foreground", "--capture", "--native-window", "--windowed"):
            with self.assertRaises(ValueError):
                background_process.validate("generic", [sys.executable, forbidden], self.root)

    def test_quiet_run_records_logs_and_exact_success_code(self):
        record = background_process.run("generic", [sys.executable, "-c", "print('ok')"], self.root, self.root / "logs", "unit", quiet_host=True, timeout=5)
        self.assertEqual(record["status"], "passed")
        self.assertEqual(record["child_exit_code"], 0)
        self.assertEqual(record["launcher_exit_code"], 0)
        self.assertEqual(record["result_source"], "child")
        self.assertTrue(Path(record["stdout"]).is_file())
        self.assertIsNotNone(record["stdout_sha256"])
        self.assertEqual(record["kill_policy"], "disabled")
        self.assertEqual(record["creationflags"], getattr(subprocess, "CREATE_NO_WINDOW", 0) if sys.platform == "win32" else 0)

    def test_failure_preserves_exact_exit_and_logs(self):
        record = background_process.run("generic", [sys.executable, "-c", "import sys; print('UNIQUE_STDOUT'); print('UNIQUE_STDERR', file=sys.stderr); sys.exit(7)"], self.root, self.root / "logs", "failure", quiet_host=True, timeout=5)
        self.assertEqual(record["status"], "failed")
        self.assertEqual(record["child_exit_code"], 7)
        self.assertEqual(record["launcher_exit_code"], 7)
        self.assertIn("UNIQUE_STDOUT", Path(record["stdout"]).read_text(encoding="utf-8"))
        self.assertIn("UNIQUE_STDERR", Path(record["stderr"]).read_text(encoding="utf-8"))

    def test_cli_returns_child_exit_code_and_record(self):
        command = [sys.executable, str(TOOLS / "background_process.py"), "run", "--profile", "generic", "--cwd", str(self.root), "--log-dir", str(self.root / "logs"), "--label", "cli-failure", "--", sys.executable, "-c", "import sys; sys.exit(7)"]
        result = subprocess.run(command, text=True, capture_output=True)
        self.assertEqual(result.returncode, 7, result.stderr)
        summary = json.loads(result.stdout)
        record = json.loads(Path(summary["record"]).read_text(encoding="utf-8"))
        self.assertEqual(record["child_exit_code"], 7)
        self.assertEqual(record["launcher_exit_code"], 7)

    def test_timeout_records_owner_and_reconcile_without_kill(self):
        record = background_process.run("generic", [sys.executable, "-c", "import time; time.sleep(0.2)"], self.root, self.root / "logs", "timeout", quiet_host=True, timeout=0.01)
        self.assertEqual(record["status"], "blocked")
        self.assertEqual(record["launcher_exit_code"], background_process.TIMEOUT_EXIT_CODE)
        self.assertEqual(record["kill_policy"], "disabled")
        self.assertIsInstance(record["child_pid"], int)
        record_path = Path(record["stdout"]).with_suffix(".json")
        background_process.write_record(record_path, record)
        reconciled = background_process.reconcile(record_path)
        self.assertIn(reconciled["reconcile_status"], {"pending", "resolved", "identity_unknown"})
        time.sleep(0.3)
        background_process.reconcile(record_path)


if __name__ == "__main__":
    unittest.main()
