# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Added `repomemo upgrade` command and `--fetch` flag, plus agent-specific
instructions in all root adapters to route project knowledge to `.ai/` instead
of agent-private memory systems.

## Files changed

- `bin/repomemo` — added `upgrade` subcommand with `--fetch` support; added
  `--fetch` to usage, help, and header comment.
- `tests/test_repomemo.sh` — added 5 upgrade tests (updates adapters, skips
  .ai/ files, creates missing adapter, preserves strict check, fails on
  missing dir); added "upgrade" to help output assertion.
- `CLAUDE.md`, `opencode.md` — added agent-specific instruction block.
- `AGENTS.md` — added no-private-memory rule to update rule section.
- `templates/CLAUDE.md`, `templates/opencode.md`, `templates/AGENTS.md` —
  synced with root adapters.
- `.ai/README.md`, `templates/.ai/README.md` — added no-private-memory rule
  to write rules.
- `.ai/memory.md` — documented upgrade command; recorded agent-private memory
  pitfall.
- `.ai/architecture.md` — added upgrade and --fetch to CLI component docs.
- `.ai/handoff.md` — this file.
- `README.md`, `README.zh.md` — added upgrade and upgrade --fetch to quick
  start, usage, and command descriptions.

## Commands run

- `bash -n bin/repomemo` → PASS.
- `bash -n tests/test_repomemo.sh` → PASS.
- `bash bin/repomemo --version` → PASS, `repomemo 1.1.0`.
- `bash bin/repomemo --help` → PASS, shows upgrade with --fetch.
- `bash tests/test_repomemo.sh` → PASS, 16 passed and 0 failed.
- `bash bin/repomemo check .` → PASS, 10 files.
- `bash bin/repomemo check --strict .` → PASS, 10 files + all strict checks.

## Checks performed

- `upgrade` updates adapter files that differ from templates; reports
  up-to-date files correctly.
- `upgrade` never touches `.ai/` files, even when they differ from templates.
- `upgrade` recreates missing adapter files.
- After `upgrade`, `check --strict` still passes.
- `upgrade --fetch` downloads the latest release tarball from GitHub, extracts
  `templates/`, and uses those templates for the upgrade. Requires curl and tar.
- `upgrade` on a non-existent directory fails with a clear error message.
- `extract_at_imports` correctly parses `@./path` imports despite the new
  agent-specific instruction block after the imports.
- `check_files_match` confirms CLAUDE.md and opencode.md remain byte-identical,
  and all root adapters match their template copies.

## Current state

- `repomemo upgrade` lets users update root adapters in already-initialized
  projects without touching their customized `.ai/` files.
- `repomemo upgrade --fetch` goes a step further: it downloads the latest
  templates from the GitHub release before applying, so users don't need to
  upgrade repomemo itself first.
- All three root adapters include instructions to route project knowledge to
  `.ai/` instead of agent-private memory systems, closing the write-path gap
  in the shared-memory design.

## Unresolved unknowns

- `--fetch` requires network access and curl+tar; offline users must upgrade
  repomemo via their package manager first, then run `repomemo upgrade` without
  `--fetch`.
- The agent-specific instructions are advisory — whether each agent fully
  suppresses its built-in private memory behavior depends on that agent's
  implementation.
- Distribution publishing state was not changed. The version remains `1.1.0`;
  decide separately whether to bump before release.

## Next safe action

Decide whether to bump the version, then commit and push. After release,
downstream projects can run `repomemo upgrade --fetch` to pull in the adapter
updates in a single command.
