# Homebrew distribution

Quicksilver uses a dedicated tap, `GOI17/homebrew-quicksilver`, like Wave's
`GOI17/homebrew-wave`. The end-user command is:

```sh
brew tap GOI17/quicksilver
brew install GOI17/quicksilver/quicksilver
quicksilver
```

Use the fully qualified formula name: Homebrew also has an unrelated Quicksilver
macOS application. The formula installs Git, Neovim, ripgrep, and the bundled Lua
configuration. It does not run `setup.sh` or modify shell or WezTerm configuration.

The executable follows Homebrew's symlinks to the current keg and starts Neovim
with that configuration. Plugins and other user data use Neovim's `quicksilver`
directories. Each release seeds a writable plugin lockfile under
`stdpath("state")/releases/<version>/lazy-lock.json`, preserving the packaged
configuration and keeping a new release's plugin versions separate from an older
release's local updates.

## Validate and package

Requires Python 3.12 or newer and Neovim for the startup check.

```sh
python3 -m unittest discover -s tests -p 'distribution_spec.py' -v
python3 scripts/package-release.py "$(cat VERSION)" --output dist
```

Packaging is deterministic and includes only `bin/quicksilver`, `VERSION`,
`init.lua`, `lazy-lock.json`, and Lua sources. The outputs are:

- `quicksilver-<version>.tar.gz`
- `SHA256SUMS`
- `quicksilver.rb`, with the matching release URL and SHA-256

## Publish a release

1. Update `VERSION`, commit the intended changes, and push them to `main`.
2. Tag that commit and push the tag:

   ```sh
   git tag "v$(cat VERSION)"
   git push origin "v$(cat VERSION)"
   ```

3. The release workflow runs the distribution tests, builds the archive, and
   publishes all three outputs to a GitHub release. Download `quicksilver.rb`
   from that release and commit it as `Formula/quicksilver.rb` in the tap.
   This explicit tap update uses no cross-repository automation secret.
4. For the first release, create the public `GOI17/homebrew-quicksilver` repository
   with that formula and a README containing the installation commands above.
5. Verify the published formula:

   ```sh
   brew tap GOI17/quicksilver
   brew install GOI17/quicksilver/quicksilver
   brew test GOI17/quicksilver/quicksilver
   quicksilver --version
   ```

Homebrew cannot install the stable formula until both the release asset and the
tap commit are published. Never regenerate or replace an already released
archive: bump `VERSION` for subsequent changes.
