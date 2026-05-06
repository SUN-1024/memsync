# Project

## Purpose

`memsync` is a small CLI tool plus a markdown scaffold. Running `memsync init`
in a repository drops a `.ai/` directory and two thin root adapter files
(`CLAUDE.md`, `AGENTS.md`) so any AI coding agent that respects either
convention reads the same project facts in the same order at session start.

It exists because:

- Different AI agents read different instruction files
  (`CLAUDE.md` resolves `@./path` imports; `AGENTS.md` is read as a plain
  numbered list).
- Without a shared layout, two agents in the same repo drift: one knows about
  a decision the other does not, and a human has to reconcile them.

The repository is both the tool and a living example of the scaffold it
generates: memsync's own `.ai/` directory follows the convention it ships.

## Users / stakeholders

- **Engineers running multiple AI coding agents on the same repo** — the
  primary audience.
- **Engineers running any single agent** that respects `AGENTS.md` or
  `CLAUDE.md` — still benefits from the structure.
- **Reviewers** of agent-authored PRs — `review-checklist.md` and
  `definition-of-done.md` give them a stable rubric.
- **Maintainers of memsync** — install via Homebrew, the curl one-liner,
  npm, or directly from a clone.

## Scope

- The `bin/memsync` Bash CLI (`init`, `check`, `--help`, `--version`).
- The `templates/` directory: source of truth for what `memsync init` writes.
- The repository's own `.ai/` directory: meta-documentation about memsync.
- Bilingual entry-point READMEs (English + Simplified Chinese).
- A Homebrew formula at `homebrew/memsync.rb` for distribution via a tap.
- A curl-pipe-bash installer at `install.sh`.
- An npm wrapper (`package.json`, published as `memsync-cli`).
- An integration test suite at `tests/test_memsync.sh`.
- A GitHub Actions release workflow that creates a GitHub release on tag push.

## Non-goals

- Not a runtime, library, or language-specific framework.
- Not a hook system or settings file generator (Claude Code's
  `settings.json`, Cursor's rules, etc. live elsewhere).
- Not opinionated about which AI coding agent is "primary" — both adapters
  are equal.
- Not a replacement for repo-specific docs like `CONTRIBUTING.md` or ADRs;
  memsync is the *agent-facing* layer that complements them.
- Not a Python / Node / Go application — keeping it as a single Bash script
  is intentional. The npm package is a thin distribution wrapper around the
  same Bash binary, not a Node implementation.

## Constraints

- Bash-compatible (works under macOS `/bin/bash` and Linux `/usr/bin/env bash`).
- Markdown only inside `.ai/` so any agent can read it.
- Tool-agnostic wording inside `.ai/`.
- Cross-platform: avoid symlinks; keep `CLAUDE.md` and `AGENTS.md` as real
  files so Windows and shallow clones work.
- The CLI is **safe by default**: `init` never overwrites without `--force`.

## Runtime assumptions

- The user has Bash 3.2+ available (the version that ships with macOS).
- The user has `cp`, `mkdir`, `find`, `readlink` — i.e. POSIX utilities.

No build step, no compiler, no language runtime is required.

## Deploy targets

- **Homebrew**: `brew tap SUN-1024/memsync && brew install memsync`. The tap
  repository (`SUN-1024/homebrew-memsync`) hosts the canonical formula; the
  copy at `homebrew/memsync.rb` in this repo is for reference and review.
- **Curl one-liner**: `curl -fsSL .../install.sh | bash`. Resolves the
  latest release tag (or `MEMSYNC_VERSION`), unpacks the source tarball,
  and installs into `$MEMSYNC_PREFIX/bin` and `$MEMSYNC_PREFIX/share`.
- **npm**: `npm install -g memsync-cli` (the package name is `memsync-cli`
  because `memsync` is taken on the npm registry; the binary is still
  `memsync`).
- **Manual install from source**: `git clone` + symlink `bin/memsync` onto
  `$PATH`.
- **GitHub releases**: source tarballs published per tag via the release
  workflow, used by Homebrew and `install.sh` as the install artifact.

## External services

- GitHub (hosting, releases, Actions).
- Homebrew (distribution).
- npm registry (distribution as `memsync-cli`).
