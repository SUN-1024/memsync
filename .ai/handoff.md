# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Added `repomemo check --verify` to validate that the shared memory system is
actually working (not just structurally correct).

## Files changed

- `bin/repomemo` — added `--verify` flag to `check`; `run_verify_checks`
  function checks memory freshness (memory.md/handoff.md differ from
  templates) and adapter instruction presence; `--verify` implies `--strict`.
- `tests/test_repomemo.sh` — added tests for verify passes on customized
  project and verify fails on fresh init; added verify to help assertions.
- `README.md`, `README.zh.md` — added `--verify` to quick start, usage, and
  check description.
- `.ai/architecture.md` — updated CLI component docs for `--verify`.
- `.ai/memory.md` — documented `--verify` in CLI conventions.
- `.ai/handoff.md` — this file.

## Commands run

- `bash -n bin/repomemo` → PASS.
- `bash tests/test_repomemo.sh` → PASS, 18 passed and 0 failed.
- `bash bin/repomemo check --verify .` → PASS, all memory verification checks pass.

## Current state

Three levels of `check`:
- `check` — files exist, non-empty
- `check --strict` — above + adapter ordering, template sync
- `check --verify` — above + memory freshness (customized from templates) +
  adapter instruction check + Claude Code private memory warning

`--verify` on a fresh init correctly fails (memory files still match
templates), confirming the check works as a guardrail.

## Next safe action

Commit, push, and consider whether to bump to v1.3.0 or include in the
already-pending v1.2.0 changes. Since v1.2.0 was just tagged, this should
either amend the release or become v1.3.0.
