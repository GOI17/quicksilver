---
name: git-release
description: Create consistent releases and changelogs for Neovim plugins
---

## What I do

- Draft release notes from merged PRs
- Propose version bumps following semantic versioning
- Generate tags and GitHub releases
- Update version numbers in config files

## When to use me

Use this when preparing a tagged release. Ask clarifying questions if the target versioning scheme is unclear.

## Workflow

1. Check git log since last tag
2. Categorize changes (feat, fix, breaking)
3. Draft changelog entries
4. Propose version bump (major/minor/patch)
5. Provide copy-pasteable commands:
   - `git tag -a v<x>.<y>.<z> -m "Release v<x>.<y>.<z>"`
   - `git push origin v<x>.<y>.<z>`

## Versioning

Follow Semantic Versioning:
- **Major** (x.0.0): Breaking changes
- **Minor** (x.y.0): New features
- **Patch** (x.y.z): Bug fixes
