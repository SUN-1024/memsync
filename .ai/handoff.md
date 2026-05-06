# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Transform memsync from a markdown-only template repository into a real
installable CLI tool while preserving the `.ai/` scaffold convention and
removing single-agent contributor branding.

## Files changed

- `bin/memsync` — new executable Bash CLI (`init`, `check`, `--help`,
  `--version`) with safe-by-default `init` and a self-resolving template
  path.
- `templates/.ai/{README,project,architecture,definition-of-done,
  review-checklist,memory,handoff}.md`, `templates/CLAUDE.md`,
  `templates/AGENTS.md` — generic, tool-neutral scaffold copied by
  `memsync init`.
- `README.md`, `README.zh.md` — rewritten as CLI-tool documentation:
  install (Homebrew + source + no-install), usage, file relationships,
  paste-a-prompt path, supported agents listed as compatibility targets,
  development and release sections.
- `AGENTS.md` — restated tool-neutral; numbered list unchanged.
- `.ai/README.md`, `.ai/project.md`, `.ai/architecture.md`,
  `.ai/definition-of-done.md`, `.ai/memory.md` — updated to describe the
  CLI reality (`bin/`, `templates/`, `tests/`, `homebrew/`,
  `.github/workflows/release.yml`) instead of a markdown-only scaffold.
- `homebrew/memsync.rb` — reference Homebrew formula with `inreplace`
  on the installed `bin/memsync` so it finds templates under
  `share/memsync/templates`. Placeholder `sha256` until the first
  release tag.
- `.github/workflows/release.yml` — release automation triggered by
  `v*.*.*` tag push: runs the integration tests, verifies that the
  hard-coded `VERSION` in `bin/memsync` matches the tag, then publishes
  a GitHub release with the source tarball and its SHA256.
- `tests/test_memsync.sh` — eight Bash assertions covering every CLI
  surface, including a self-check against the repository's own `.ai/`.
- `.ai/handoff.md` — this file, rewritten to reflect the latest task.

## Commands run

- `bash bin/memsync --version` → `memsync 1.0.0`
- `bash bin/memsync --help` → usage banner shown
- `bash bin/memsync check .` → 9/9 PASS
- `bash tests/test_memsync.sh` → 8/8 PASS
- `git add … && git commit -m …` (one commit per phase, see git log)
- `git status` → clean

## Checks performed

- Integration suite green: `tests/test_memsync.sh` exits 0.
- Self-check green: `bin/memsync check .` exits 0 against this repo.
- `bin/memsync` committed with mode `100755`; `tests/test_memsync.sh`
  also `100755`.
- `CLAUDE.md` and `AGENTS.md` (root *and* `templates/`) list the same
  seven `.ai/` files in the same order as `.ai/README.md`.
- No `TODO`/`TBD`/placeholder text inside `.ai/` after the rewrite.
- No new contributor language naming a single AI agent as author or
  maintainer.

## Current state

- The repository is both the CLI tool and the convention it ships:
  `bin/memsync` writes `templates/` content into a target repo, and the
  repository's own `.ai/` follows the convention internally.
- Distribution path is in place but unreleased: the GitHub Actions
  workflow will create a real release when a `v1.0.0` tag is pushed,
  and the Homebrew formula is structurally complete with a placeholder
  `sha256` to be replaced after that release.
- All eight commits since project inception are linear on `main`; the
  branch is clean.

## Unresolved unknowns

- The first real release tag (`v1.0.0`) has not yet been pushed, so the
  GitHub Actions workflow has not run end-to-end and the Homebrew
  `sha256` is still a placeholder. The workflow itself is plausible but
  unverified against GitHub's release runner.
- The canonical Homebrew tap repository `SUN-1024/homebrew-memsync` is
  referenced in docs but its current contents are not part of this
  repository.
- The bilingual READMEs were re-read end-to-end after the rewrite, but
  no automated check enforces that they stay mirrored.

## Next safe action

For the maintainer:

1. Push tag `v1.0.0` to trigger the release workflow; copy the SHA256
   reported by the workflow into `homebrew/memsync.rb` and the
   canonical formula in `SUN-1024/homebrew-memsync`.
2. Tap-test: `brew tap SUN-1024/memsync && brew install memsync &&
   memsync --version`.
3. After tap-testing succeeds, optionally add a CHANGELOG; until a
   second meaningful change lands, this `handoff.md` plus `git log`
   are sufficient.

For a downstream consumer:

1. `brew install memsync` (after the v1.0.0 release lands) or
   `git clone … && bin/memsync init` from a clone.
2. Edit the generated `.ai/project.md` and `.ai/architecture.md` to
   describe the real project, then replace the *Required commands*
   section of `.ai/definition-of-done.md` with the project's actual
   build/test/lint commands.
3. Reset `.ai/handoff.md` so it describes the adoption itself as the
   latest task.
