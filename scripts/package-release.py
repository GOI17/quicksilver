#!/usr/bin/env python3
"""Build the portable release payload and its matching Homebrew formula."""

import argparse
import gzip
import hashlib
import io
from pathlib import Path
import re
import tarfile


def package(root, output, version):
    if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise ValueError("Version must have the form 0.1.0")
    if (root / "VERSION").read_text().strip() != version:
        raise ValueError("Release version must match VERSION")

    # Explicit payload: never ship the workspace, sibling projects, or dotfiles.
    files = [root / path for path in ("VERSION", "init.lua", "lazy-lock.json", "bin/quicksilver")]
    files += sorted((root / "lua").rglob("*.lua"))
    output.mkdir(parents=True, exist_ok=True)
    archive = output / f"quicksilver-{version}.tar.gz"
    with archive.open("wb") as raw:
        with gzip.GzipFile(filename="", fileobj=raw, mode="wb", mtime=0) as compressed:
            with tarfile.open(fileobj=compressed, mode="w", format=tarfile.PAX_FORMAT) as tar:
                for path in files:
                    if path.is_symlink():
                        raise ValueError(f"Release files must not be symlinks: {path}")
                    relative = path.relative_to(root).as_posix()
                    content = path.read_bytes()
                    entry = tarfile.TarInfo(f"quicksilver-{version}/{relative}")
                    entry.size = len(content)
                    entry.mode = 0o755 if relative == "bin/quicksilver" else 0o644
                    tar.addfile(entry, io.BytesIO(content))

    checksum = hashlib.sha256(archive.read_bytes()).hexdigest()
    (output / "SHA256SUMS").write_text(f"{checksum}  {archive.name}\n")
    template = (root / "homebrew/quicksilver.rb.in").read_text()
    (output / "quicksilver.rb").write_text(
        template.replace("@VERSION@", version).replace("@SHA256@", checksum)
    )
    return archive


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("version")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    try:
        print(package(Path(__file__).resolve().parents[1], args.output, args.version))
    except ValueError as error:
        parser.error(str(error))
