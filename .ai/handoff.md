# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Ship the first real release (`v1.0.0`) and add two more install paths
beyond Homebrew: a curl one-liner (`install.sh`) and an npm wrapper
(`memsync-cli`). Mirror all this into the bilingual READMEs and the
repository's own `.ai/`.

## Files changed

- `install.sh` — curl-pipe-bash installer. Resolves the latest release
  tag (or `MEMSYNC_VERSION`), downloads the source tarball, installs
  `bin/memsync` and `templates/` under `MEMSYNC_PREFIX` (default
  `/usr/local`), and rewrites `TEMPLATE_DIR` in the installed script so
  it points at `$PREFIX/share/memsync/templates`. Uses `sudo` only when
  the prefix is not writable.
- `package.json` — npm wrapper around the same Bash CLI. Package name
  is `memsync-cli` (because `memsync` was taken on the npm registry);
  the binary remains `memsync` via the `bin` field.
- `homebrew/memsync.rb` — `sha256` pinned to the real release artifact
  (`254429bc4b1e20d3123ecc1008a002f29c21c4d317cc136437a4cfcfe3d18baf`),
  no longer a placeholder.
- `README.md`, `README.zh.md` — added a *Quick start* section listing
  the three primary install methods (brew / curl / npm) followed by
  `init` / `check` / customize-and-commit. Expanded the *Install*
  section with full curl one-liner and npm subsections, kept the
  prompt-based "no CLI" path intact.
- `.ai/architecture.md` — added `install.sh` and `package.json` to the
  repository layout, added matching component entries, updated the
  data-flow diagram to show three install channels and updated the
  *Dependencies* note to mention `curl`/`tar`/`awk`.
- `.ai/project.md` — `Scope` now lists the curl installer and the npm
  wrapper; `Deploy targets` documents all three channels and the
  `memsync-cli` name; `External services` adds the npm registry; the
  Node non-goal is clarified ("npm wrapper, not a Node implementation").
- `.ai/memory.md` — `Distribution` records the npm-name detail, the
  `install.sh` URL contract, and the four-file version-bump checklist
  (`bin/memsync`, `homebrew/memsync.rb`, `package.json`, git tag).
- `.ai/handoff.md` — this file.

External (not in this repo):

- `SUN-1024/homebrew-memsync` (tap repo) — `Formula/memsync.rb` and
  `README.md` pushed; `brew tap SUN-1024/memsync && brew install memsync`
  works against the live release.
- GitHub release `v1.0.0` published by `.github/workflows/release.yml`,
  with the source tarball and its SHA256 in the release body.

## Commands run

- `bash tests/test_memsync.sh` → 8/8 PASS
- `bash bin/memsync check .` → 9/9 PASS
- `git tag v1.0.0 && git push --tags` → release workflow triggered
- Manual `shasum -a 256` of the downloaded tarball matched the
  workflow output before the formula was pinned.
- `brew tap SUN-1024/memsync && brew install memsync && memsync --version`
  → `memsync 1.0.0`
- `MEMSYNC_PREFIX=$(mktemp -d) MEMSYNC_VERSION=v1.0.0 bash install.sh`
  → `memsync 1.0.0`; subsequent `memsync init` produced the full
  9-file scaffold and `memsync check` reported 9/9 PASS.
- `npm pack && npm install -g --prefix "$tmp" memsync-cli-1.0.0.tgz`
  → `memsync 1.0.0` from the installed binary.
- `git status` → clean before this commit.

## Checks performed

- Integration suite green: `tests/test_memsync.sh` exits 0.
- Self-check green: `bin/memsync check .` exits 0 against this repo.
- All three install paths exercised end-to-end against the live
  `v1.0.0` release: brew tap, curl one-liner, and `npm install -g`.
- READMEs cross-read: `README.md` and `README.zh.md` cover the same
  three install methods, the same Quick start, and the same prompt
  fallback.
- `.ai/architecture.md`'s file tree matches `ls` of the repo root.
- `.ai/memory.md`'s version-bump rule matches the current state of
  `bin/memsync`, `homebrew/memsync.rb`, and `package.json` (all at
  `1.0.0`).
- No `TODO`/`TBD`/placeholder text inside `.ai/` after the rewrite.
- No new contributor language naming a single AI agent as author or
  maintainer.

## Current state

- `v1.0.0` is live: GitHub release published, tap repo populated,
  Homebrew install verified.
- Three install paths are documented and tested:
  `brew install memsync`, the curl one-liner, and
  `npm install -g memsync-cli`.
- The repository continues to be both the tool and the convention it
  ships: `bin/memsync` writes `templates/` content into a target repo,
  and the repository's own `.ai/` follows the same convention.

## Unresolved unknowns

- The npm package has not been published to the public registry yet
  (`npm publish` is the maintainer's next manual step). Local
  verification used `npm pack` + `npm install -g` from the tarball.
- The curl installer was tested against the live release but only on
  macOS; behavior under bare Linux container images (e.g. Alpine,
  which lacks `bash` by default) has not been exercised.
- The bilingual READMEs are kept in sync by hand. There is still no
  automated mirror check.

## Next safe action

For the maintainer:

1. `npm publish` against the npm registry to make
   `npm install -g memsync-cli` work for end users (the tarball has
   already been verified locally).
2. Optionally run the curl installer on a clean Linux image
   (e.g. `docker run --rm -it debian:stable-slim bash -lc 'apt-get
   update && apt-get install -y curl ca-certificates && curl -fsSL
   .../install.sh | bash'`) to confirm cross-distro behavior.
3. When cutting `v1.0.1` or later, update `bin/memsync`,
   `homebrew/memsync.rb`, and `package.json` together; then
   `git tag … && git push --tags`. The workflow handles the rest.

For a downstream consumer:

1. Pick any of `brew install memsync`,
   `curl … install.sh | bash`, or `npm install -g memsync-cli`.
2. `memsync init` inside the target repo, then edit
   `.ai/project.md` and `.ai/architecture.md` to describe the real
   project; replace the *Required commands* section of
   `.ai/definition-of-done.md` with the project's actual
   build/test/lint commands.
3. Reset `.ai/handoff.md` so it describes the adoption itself as the
   latest task.
