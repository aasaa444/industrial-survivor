import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace

TOOLS = Path(__file__).resolve().parent
sys.path.insert(0, str(TOOLS))
from player_slice_capture import EnvironmentBlocked, RealInputGuard, hold_keys, tap


class FakeWindowApi:
    def __init__(self, foreground=100, pid=200, visible=True):
        self.foreground = foreground
        self.pid = pid
        self.visible = visible
        self.sent = []

    def GetForegroundWindow(self):
        return self.foreground

    def IsWindow(self, hwnd):
        return hwnd == 100

    def IsWindowVisible(self, hwnd):
        return self.visible

    def GetWindowThreadProcessId(self, hwnd, pointer):
        pointer._obj.value = self.pid if hwnd == 100 else 999

    def SendInput(self, count, input_value, size):
        self.sent.append((count, size))
        return 1


def guard(api, allow=True, sender=None):
    return RealInputGuard(
        hwnd=100,
        game_pid=200,
        allow_real_input=allow,
        window_api=api,
        input_sender=sender,
    )


class InputGuardTests(unittest.TestCase):
    def test_disabled_guard_sends_nothing(self):
        api = FakeWindowApi()
        with self.assertRaises(EnvironmentBlocked):
            tap("W", guard(api, allow=False), hold=0)
        self.assertEqual(api.sent, [])

    def test_wrong_foreground_sends_nothing(self):
        api = FakeWindowApi(foreground=300)
        with self.assertRaises(EnvironmentBlocked) as error:
            tap("W", guard(api), hold=0)
        self.assertEqual(api.sent, [])
        self.assertEqual(error.exception.environment["actual_foreground_hwnd"], 300)

    def test_focus_loss_after_key_down_emergency_releases_key(self):
        api = FakeWindowApi()
        guarded = guard(api)

        def sender(vk, up):
            api.sent.append((vk, up))
            if not up:
                api.foreground = 300

        guarded.input_sender = sender
        with self.assertRaises(EnvironmentBlocked):
            tap("W", guarded, hold=0)
        self.assertEqual(api.sent, [(0x57, False), (0x57, True)])
        self.assertEqual(guarded.cleanup_receipts[0]["event"], "emergency_release_after_focus_loss")
        self.assertEqual(guarded.cleanup_receipts[0]["result"], "sent")

    def test_hold_keys_releases_all_pressed_keys_after_focus_loss(self):
        api = FakeWindowApi()
        guarded = guard(api)

        def sender(vk, up):
            api.sent.append((vk, up))
            if vk == 0x57 and not up:
                api.foreground = 300

        guarded.input_sender = sender
        with self.assertRaises(EnvironmentBlocked):
            hold_keys(["W", "D"], 0.1, guarded, poll_interval=0)
        self.assertEqual(api.sent, [(0x57, False), (0x57, True)])
        self.assertEqual(guarded.pressed_vks, [])

    def test_parent_ownership_is_checked(self):
        api = FakeWindowApi()
        ownership = {200: 999}
        guarded = RealInputGuard(
            hwnd=100,
            game_pid=200,
            console_pid=888,
            allow_real_input=True,
            window_api=api,
            parent_lookup=ownership.get,
            input_sender=lambda *_: api.sent.append(True),
        )
        with self.assertRaises(EnvironmentBlocked):
            guarded.send(0x57, False)
        self.assertEqual(api.sent, [])

    def test_cli_defaults_disable_real_input(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            units = root / "units.json"
            units.write_text("[]", encoding="utf-8")
            commands = [
                [sys.executable, str(TOOLS / "player_slice_capture.py"), "--project-root", str(root), "--out-dir", str(root / "p3" )],
                [sys.executable, str(TOOLS / "defeat_run_capture.py"), "--project-root", str(root), "--out-dir", str(root / "p4" )],
                [sys.executable, str(TOOLS / "export_release_check.py"), "--exe", str(root / "missing.exe"), "--out-dir", str(root / "p6" )],
            ]
            for command in commands:
                result = subprocess.run(command, text=True, capture_output=True)
                self.assertEqual(result.returncode, 2, result.stderr)
                output = result.stdout + result.stderr
                self.assertIn("input_disabled", output)
                self.assertNotIn("Industrial Survivor", output)


if __name__ == "__main__":
    unittest.main()
