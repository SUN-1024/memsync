# Project

## Purpose

`repomemo` is a small CLI tool plus a markdown scaffold. Running `repomemo init`
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
generates: repomemo's own `.ai/` directory follows the convention it ships.

## Users / stakeholders

- **Engineers running multiple AI coding agents on the same repo** — the
  primary audience.
- **Engineers running any single agent** that respects `AGENTS.md` or
  `CLAUDE.md` — still benefits from the structure.
- **Reviewers** of agent-authored PRs — `review-checklist.md` and
  `definition-of-done.md` give them a stable rubric.
- **Maintainers of repomemo** — install via Homebrew, the curl one-liner,
  npm, or directly from a clone.

## Scope

- The `bin/repomemo` Bash CLI (`init`, `check`, `--help`, `--version`).
- The `templates/` directory: source of truth for what `repomemo init` writes.
- The repository's own `.ai/` directory: meta-documentation about repomemo.
- Bilingual entry-point READMEs (English + Simplified Chinese).
- A Homebrew formula at `homebrew/repomemo.rb` for distribution via a tap.
- A curl-pipe-bash installer at `install.sh`.
- An npm wrapper (`package.json`, published as `repomemo`).
- An integration test suite at `tests/test_repomemo.sh`.
- A GitHub Actions release workflow that creates a GitHub release on tag push.

## Non-goals

- Not a runtime, library, or language-specific framework.
- Not a hook system or settings file generator (Claude Code's
  `settings.json`, Cursor's rules, etc. live elsewhere).
- Not opinionated about which AI coding agent is "primary" — both adapters
  are equal.
- Not a replacement for repo-specific docs like `CONTRIBUTING.md` or ADRs;
  repomemo is the *agent-facing* layer that complements them.
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

- **Homebrew**: `brew tap SUN-1024/repomemo && brew install repomemo`. The tap
  repository (`SUN-1024/homebrew-repomemo`) hosts the canonical formula; the
  copy at `homebrew/repomemo.rb` in this repo is for reference and review.
- **Curl one-liner**: `curl -fsSL .../install.sh | bash`. Resolves the
  latest release tag (or `REPOMEMO_VERSION`), unpacks the source tarball,
  and installs into `$REPOMEMO_PREFIX/bin` and `$REPOMEMO_PREFIX/share`.
- **npm**: `npm install -g repomemo` (the package name is `repomemo`
  because `repomemo` is taken on the npm registry; the binary is still
  `repomemo`).
- **Manual install from source**: `git clone` + symlink `bin/repomemo` onto
  `$PATH`.
- **GitHub releases**: source tarballs published per tag via the release
  workflow, used by Homebrew and `install.sh` as the install artifact.

## External services

- GitHub (hosting, releases, Actions).
- Homebrew (distribution).
- npm registry (distribution as `repomemo`).
