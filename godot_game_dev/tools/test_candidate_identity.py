import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

TOOLS = Path(__file__).resolve().parent
import sys
sys.path.insert(0, str(TOOLS))
from candidate_identity import calculate


class CandidateIdentityTests(unittest.TestCase):
    def setUp(self):
        self.temp = Path(tempfile.mkdtemp(prefix="candidate-identity-"))
        subprocess.run(["git", "init"], cwd=self.temp, check=True, stdout=subprocess.DEVNULL)
        subprocess.run(["git", "config", "user.email", "test@example.invalid"], cwd=self.temp, check=True)
        subprocess.run(["git", "config", "user.name", "Test"], cwd=self.temp, check=True)
        (self.temp / "tracked.txt").write_text("tracked", encoding="utf-8")
        subprocess.run(["git", "add", "tracked.txt"], cwd=self.temp, check=True)
        subprocess.run(["git", "commit", "-m", "initial"], cwd=self.temp, check=True, stdout=subprocess.DEVNULL)

    def tearDown(self):
        shutil.rmtree(self.temp, ignore_errors=True)

    def test_untracked_content_changes_identity(self):
        artifact = self.temp / "new_tool.py"
        artifact.write_text("one", encoding="utf-8")
        first = calculate(self.temp)
        artifact.write_text("two", encoding="utf-8")
        second = calculate(self.temp)
        self.assertEqual(first["identity_version"], "git-worktree-v2")
        self.assertNotEqual(first["working_tree_sha256"], second["working_tree_sha256"])
        self.assertNotEqual(first["untracked_content_sha256"], second["untracked_content_sha256"])

    def test_runtime_outputs_are_excluded(self):
        runtime = self.temp / ".zcode" / "slice-runtime"
        runtime.mkdir(parents=True)
        (runtime / "state.json").write_text("one", encoding="utf-8")
        first = calculate(self.temp)
        (runtime / "state.json").write_text("two", encoding="utf-8")
        second = calculate(self.temp)
        self.assertEqual(first["working_tree_sha256"], second["working_tree_sha256"])


if __name__ == "__main__":
    unittest.main()
