# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Rename the project from `memsync` to `RepoMemo` (CLI binary: `repomemo`).
Every file, path, URL, package name, env var, and class name updated.

## Files changed

- `bin/repomemo` (renamed from `bin/memsync`) — CLI script; all references
  updated.
- `homebrew/repomemo.rb` (renamed from `homebrew/memsync.rb`) — class
  `Repomemo`, desc, url, inreplace, and test block updated.
- `tests/test_repomemo.sh` (renamed from `tests/test_memsync.sh`) —
  binary path, test names, temp dir prefix updated.
- `install.sh` — repo, binary, share paths, env vars (`REPOMEMO_VERSION`,
  `REPOMEMO_PREFIX`), error messages updated.
- `package.json` — name `repomemo`, all URLs, bin, scripts updated.
- `README.md`, `README.zh.md` — title `RepoMemo`, all references, npm
  disclaimers removed (bare name is available), env var names updated.
- `.ai/architecture.md`, `.ai/project.md`, `.ai/definition-of-done.md`,
  `.ai/memory.md` — all references updated; npm `-cli` suffix and
  disclaimer removed.
- `.ai/handoff.md` — this file.
- `.github/workflows/release.yml` — test and binary paths, tarball names,
  release body, formula path updated.
- `templates/.ai/handoff.md` — scaffold reference updated.

## Commands run

- `bash tests/test_repomemo.sh` → 8/8 PASS
- `bash bin/repomemo check .` → 9/9 PASS
- `git status` → clean before this commit.

## Checks performed

- `grep -rn memsync` across the repo (excluding .git/) returns nothing.
- `grep -rn repomemo-cli` returns nothing; `grep -rn MEMSYNC_` returns
  nothing.
- Integration suite green.
- Self-check green.
- No `TODO`/`TBD`/placeholder text inside `.ai/`.

## Current state

- All 14 files renamed or edited; the repo is a consistent `repomemo`
  codebase.
- The old `v1.0.0` release infrastructure still references `memsync` on
  GitHub (tap repo `SUN-1024/homebrew-memsync`, release tag `v1.0.0`,
  published tarball). Those external artifacts will be replaced when a
  fresh release is cut from the renamed repo.

## Unresolved unknowns

- GitHub repo has not been renamed from `SUN-1024/memsync` to
  `SUN-1024/repomemo`. This must be done manually by the owner via GitHub
  Settings.
- The Homebrew tap `SUN-1024/homebrew-repomemo` does not exist yet; it
  must be created and populated with the renamed formula after the GitHub
  repo is renamed.
- A new release tag (e.g. `v1.0.0` or `v1.0.1`) must be pushed after the
  GitHub rename to trigger a fresh release with the correct artifact
  name.
- `npm publish` is still pending; it will now publish as `repomemo`
  instead of `memsync-cli`.

## Next safe action

For the maintainer:

1. Rename the GitHub repo `SUN-1024/memsync` → `SUN-1024/repomemo` via
   GitHub Settings (this keeps stars, watchers, and redirects old URLs).
2. Create the tap repo `SUN-1024/homebrew-repomemo` and push the renamed
   formula.
3. Push a new tag (`v1.0.1` recommended, since `v1.0.0` already exists
   under the old name) to trigger a fresh release.
4. `npm publish` from the renamed repo.
