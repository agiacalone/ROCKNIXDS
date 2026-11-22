"""The repair after ROCKNIX resets DraStic's folder. ROCKNIX's factoryreset standalone (which 20261101's post-update
runs once) deletes /storage/.config/drastic and libdsflip with it. The autostart hook must ask for a repair only
then, not on a handheld without ROCKNIXDS, with libdsflip in place, or installed with --no-dsflip. The repair must
reinstall exactly the installed ref, never one it can't download, and start without waiting on ROCKNIX's
autostart (systemd-run --no-block)."""
import os
import subprocess
import tempfile
import unittest
from pathlib import Path

from loadmod import ROOT

HOOK = ROOT / "dsflip/device/autostart-rocknixds-repair"
UPDATE = ROOT / "dsflip/device/rocknixds-update"


class RepairHookTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.state = self.root / "rocknixds"
        self.drastic = self.root / "drastic"
        self.state.mkdir()
        self.calls = self.root / "calls"
        self.update = self.root / "rocknixds-update"
        self.update.write_text(f'#!/bin/sh\necho "$*" >> "{self.calls}"\n')
        self.update.chmod(0o755)

    def tearDown(self):
        self.tmp.cleanup()

    def run_hook(self):
        env = dict(os.environ, ROCKNIXDS_STATE=str(self.state), ROCKNIXDS_DRASTIC=str(self.drastic),
                   ROCKNIXDS_UPDATE=str(self.update))
        r = subprocess.run(["sh", str(HOOK)], env=env, capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stderr)
        return self.calls.read_text().split("\n")[0] if self.calls.exists() else None

    def installed(self, ref="v1.6.4.8-plus"):
        (self.state / "installed-id").write_text(ref + "\n")

    def test_not_installed(self):
        self.assertIsNone(self.run_hook())

    def test_libdsflip_in_place(self):
        self.installed()
        (self.drastic / "dsflip").mkdir(parents=True)
        (self.drastic / "dsflip/libdsflip.so").write_bytes(b"")
        self.assertIsNone(self.run_hook())

    def test_reset_asks_for_repair(self):
        self.installed()
        self.drastic.mkdir()        # ROCKNIX's stock folder: no dsflip/
        self.assertEqual(self.run_hook(), "repair")

    def test_no_dsflip_install(self):
        self.installed()
        (self.state / "no-dsflip").touch()
        self.assertIsNone(self.run_hook())


class RepairCommandTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.state = self.root / "rocknixds"
        self.state.mkdir()
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.log = self.root / "systemd-run.log"
        self.stub("systemctl", "#!/bin/sh\nexit 3\n")       # no update unit running
        self.stub("systemd-run", f'#!/bin/sh\necho "$*" >> "{self.log}"\n')
        (self.root / "model").write_text("Anbernic RG DS Plus\0")
        (self.root / "cfg").write_text("rocknixds.channel=stable\n")
        self.run_copy = self.root / "repair-copy.sh"

    def tearDown(self):
        self.tmp.cleanup()

    def stub(self, name, body):
        p = self.bin / name
        p.write_text(body)
        p.chmod(0o755)

    def repair(self, installed):
        if installed is not None:
            (self.state / "installed-id").write_text(installed + "\n")
        env = dict(os.environ, PATH=f"{self.bin}:{os.environ['PATH']}", ROCKNIXDS_STATE=str(self.state),
                   ROCKNIXDS_CFG=str(self.root / "cfg"), ROCKNIXDS_MODEL_FILE=str(self.root / "model"),
                   ROCKNIXDS_MODES_GLOB=str(self.root / "none"), ROCKNIXDS_REPAIR_RUN=str(self.run_copy))
        return subprocess.run(["sh", str(UPDATE), "repair"], env=env, capture_output=True, text=True)

    def test_refuses_what_it_cannot_download(self):
        for installed in (None, "unknown", "local"):
            r = self.repair(installed)
            self.assertEqual(r.returncode, 1, installed)
            self.assertIn("NOTHING TO REPAIR FROM", r.stdout)
            self.assertFalse(self.log.exists())

    def test_reinstalls_the_installed_ref_without_blocking(self):
        r = self.repair("v1.6.4.7-plus")
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertIn("STARTED", r.stdout)
        args = self.log.read_text().split()
        self.assertIn("--no-block", args)
        # a copy runs, since the installer replaces rocknixds-update itself; the exact ref and the channel's branch
        self.assertEqual(args[-5:], ["sh", str(self.run_copy), "repair-run", "v1.6.4.7-plus", "main"])
        self.assertEqual(self.run_copy.read_bytes(), UPDATE.read_bytes())


if __name__ == "__main__":
    unittest.main()
