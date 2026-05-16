# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Added `repomemo fix` command that repairs common shared-memory problems.

## Files changed

- `bin/repomemo` — added `fix` subcommand with `adapter_is_corrupted` and
  `agents_is_corrupted` detection helpers. `cmd_fix` restores corrupted root
  adapters (saving old content to `.ai/recovered-*.md`), fills missing `.ai/`
  files from templates, warns about external memory stores, and runs
  `check --verify` afterward.
- `.ai/handoff.md` — this file.

## Commands run

- `bash -n bin/repomemo` → PASS.
- `bash tests/test_repomemo.sh` → PASS, 18 passed and 0 failed.
- `bash bin/repomemo fix .` → ok CLAUDE.md, ok AGENTS.md, ok opencode.md.
- Manual test: corrupted adapters detected, recovered, and restored correctly.

## Current state

Four levels of repair/validation:
- `repomemo upgrade` — proactive: update adapters from latest templates
- `repomemo check` — files exist, non-empty
- `repomemo check --strict` — adapter ordering, template sync
- `repomemo check --verify` — memory freshness, adapter instructions
- `repomemo fix` — reactive: repair corrupted adapters, restore missing files,
  warn about external memory, then auto-run `check --verify`

## Next safe action

Bump version to v1.4.0 or include in pending v1.3.0 changes. Commit and push.
