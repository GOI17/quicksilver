import hashlib
import json
import os
from pathlib import Path
import runpy
import shutil
import subprocess
import tarfile
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
PACKAGE = runpy.run_path(str(ROOT / "scripts/package-release.py"))["package"]
VERSION = (ROOT / "VERSION").read_text().strip()


class DistributionTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="quicksilver distribution ")
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name).resolve()
        self.archive = PACKAGE(ROOT, self.base / "dist", VERSION)
        with tarfile.open(self.archive) as archive:
            archive.extractall(self.base / "keg", filter="data")
        self.config = self.base / "keg" / f"quicksilver-{VERSION}"
        self.launcher = self.config / "bin/quicksilver"

    def run_launcher(self, *args, env=None, launcher=None):
        result = subprocess.run(
            [str(launcher or self.launcher), *args], cwd=self.base,
            env=env, text=True, capture_output=True, timeout=30,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        return result.stdout

    def test_version(self):
        self.assertEqual(self.run_launcher("--version").strip(), f"Quicksilver v{VERSION}")

    def test_package_is_reproducible_and_contains_only_runtime_files(self):
        second = PACKAGE(ROOT, self.base / "second", VERSION)
        self.assertEqual(self.archive.read_bytes(), second.read_bytes())
        with tarfile.open(self.archive) as archive:
            for member in archive:
                path = member.name.removeprefix(f"quicksilver-{VERSION}/")
                self.assertTrue(
                    path in ("VERSION", "init.lua", "lazy-lock.json", "bin/quicksilver")
                    or (path.startswith("lua/") and path.endswith(".lua")), path,
                )
                self.assertFalse(member.issym())
        digest = hashlib.sha256(self.archive.read_bytes()).hexdigest()
        formula = (self.base / "dist/quicksilver.rb").read_text()
        self.assertIn(f'sha256 "{digest}"', formula)
        self.assertIn(f"/v{VERSION}/quicksilver-{VERSION}.tar.gz", formula)
        self.assertEqual((self.base / "dist/SHA256SUMS").read_text(), f"{digest}  {self.archive.name}\n")

    def test_rejects_version_that_does_not_match_source(self):
        for version in ("../../escape", "99.99.99"):
            with self.assertRaises(ValueError):
                PACKAGE(ROOT, self.base / "invalid", version)

    def test_symlink_launcher_preserves_arguments_and_uses_bundled_config(self):
        fakebin = self.base / "fakebin"
        fakebin.mkdir()
        fake_nvim = fakebin / "nvim"
        fake_nvim.write_text(
            "#!/usr/bin/env python3\n"
            "import json, os, sys\n"
            "print(json.dumps({'args': sys.argv[1:], 'app': os.environ['NVIM_APPNAME'], "
            "'config': os.environ['QUICKSILVER_CONFIG_DIR'], 'cwd': os.getcwd()}))\n"
        )
        fake_nvim.chmod(0o755)
        prefix_bin = self.base / "prefix/bin"
        prefix_bin.mkdir(parents=True)
        link = prefix_bin / "quicksilver"
        link.symlink_to(os.path.relpath(self.launcher, prefix_bin))
        env = dict(os.environ, PATH=f"{fakebin}{os.pathsep}{os.environ['PATH']}")
        result = json.loads(self.run_launcher("file with spaces.txt", "+42", env=env, launcher=link))
        self.assertEqual(result["args"], ["-u", str(self.config / "init.lua"), "file with spaces.txt", "+42"])
        self.assertEqual(result["app"], "quicksilver")
        self.assertEqual(result["config"], str(self.config))
        self.assertEqual(result["cwd"], str(self.base))

    @unittest.skipUnless(shutil.which("nvim"), "Neovim is required for the startup check")
    def test_packaged_startup_and_reload_use_bundle_and_writable_lockfile(self):
        env = dict(os.environ)
        for name in ("CONFIG", "DATA", "STATE", "CACHE"):
            env[f"XDG_{name}_HOME"] = str(self.base / name.lower())
        # Stub only the plugin manager: exercise the real bundled core without
        # downloading plugins or touching the user's Neovim directories.
        lazy = Path(env["XDG_DATA_HOME"]) / "quicksilver/lazy/lazy.nvim/lua/lazy/init.lua"
        lazy.parent.mkdir(parents=True)
        lazy.write_text("return { setup = function(opts) vim.g.test_lockfile = opts.lockfile end, sync = function() end }")
        conflicting = Path(env["XDG_CONFIG_HOME"]) / "quicksilver/lua/quicksilver/options.lua"
        conflicting.parent.mkdir(parents=True)
        conflicting.write_text('error("Loaded the old configuration instead of the bundle")')
        expected_lock = Path(env["XDG_STATE_HOME"]) / f"quicksilver/releases/{VERSION}/lazy-lock.json"
        original_lock = (self.config / "lazy-lock.json").read_bytes()
        checks = [
            'assert(vim.v.errmsg == "", vim.v.errmsg)',
            f"assert(vim.g.quicksilver_config_dir == {json.dumps(str(self.config))})",
            f"assert(vim.g.test_lockfile == {json.dumps(str(expected_lock))})",
            'assert(vim.o.shiftwidth == 2)',
            'vim.o.shiftwidth = 8; vim.cmd("Reload"); assert(vim.o.shiftwidth == 2)',
            'assert(vim.v.errmsg == "", vim.v.errmsg)',
        ]
        for path in (self.config / "lua").rglob("*.lua"):
            checks.append(f"assert(loadfile({json.dumps(str(path))}))")
        command = "lua local ok, err = pcall(function() " + "; ".join(checks)
        command += ' end); if not ok then io.stderr:write(tostring(err)); vim.cmd("cquit 1") end'
        self.run_launcher("--headless", "-i", "NONE", "+" + command, "+qa!", env=env)
        self.assertEqual(expected_lock.read_bytes(), original_lock)
        self.assertEqual((self.config / "lazy-lock.json").read_bytes(), original_lock)
        # A second launch must retain the user's plugin lock updates.
        expected_lock.write_text("{}\n")
        self.run_launcher("--headless", "-i", "NONE", "+" + command, "+qa!", env=env)
        self.assertEqual(expected_lock.read_text(), "{}\n")


if __name__ == "__main__":
    unittest.main()
