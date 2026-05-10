# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Add a stricter `repomemo check --strict` mode that verifies adapter and
template synchronization, then document and test that behavior.

## Files changed

- `bin/repomemo` — added `check --strict`, strict adapter read-order checks,
  `CLAUDE.md`/`opencode.md` content drift detection, and source-repo
  `templates/` sync checks against `SCAFFOLD_FILES`.
- `tests/test_repomemo.sh` — added coverage for `--strict` help output,
  strict success after init, strict adapter drift failure, and strict self-check.
- `README.md`, `README.zh.md` — documented `repomemo check --strict` and added
  strict self-check examples.
- `homebrew/repomemo.rb` — extended the formula test to run
  `repomemo check --strict` on an initialized target.
- `.ai/architecture.md` — updated the CLI description from 9 to 10 scaffold
  files and documented strict check behavior.
- `.ai/definition-of-done.md` — added strict self-check to required
  verification and included `opencode.md` in adapter review expectations.
- `.ai/README.md`, `.ai/project.md` — corrected stale two-adapter wording so
  the project memory consistently names `CLAUDE.md`, `AGENTS.md`, and
  `opencode.md`.
- `.ai/review-checklist.md` — updated the adapter sync checklist to include
  `opencode.md` and corrected scaffold test expectations.
- `.ai/memory.md` — recorded durable knowledge about `check --strict`.
- `.ai/handoff.md` — this file.

## Commands run

- `bash -n bin/repomemo` → PASS.
- `bash -n tests/test_repomemo.sh` → PASS.
- `bash bin/repomemo --version` → PASS, printed `repomemo 1.1.0`.
- `bash bin/repomemo --help` → PASS, shows `repomemo check [--strict] [PATH]`.
- `bash tests/test_repomemo.sh` → PASS, 11 passed and 0 failed.
- `bash bin/repomemo check .` → PASS, 10 files checked.
- `bash bin/repomemo check --strict .` → PASS, 10 files plus strict adapter
  and template sync checks.
- `rg` stale wording scan for nine-file and two-adapter phrases → PASS, no
  stale wording found.
- `rg -n 'check \\[PATH\\]|repomemo check \\[PATH\\]' .ai README.md README.zh.md bin tests homebrew` → PASS, no stale usage form found.
- `rg` stale wording scan for `CLAUDE.md`/`AGENTS.md`-only compatibility
  phrases → PASS, no stale two-adapter compatibility wording found.
- Manager-agent audit → PASS for strict-check behavior; it flagged stale
  scaffold test wording in `.ai/review-checklist.md`, which was corrected.

## Checks performed

- Default `repomemo check` remains backward compatible: it still validates
  scaffold file presence and non-empty content.
- `repomemo check --strict` validates:
  - `CLAUDE.md` imports the seven `.ai/` files in the expected order.
  - `opencode.md` imports the same seven `.ai/` files in the expected order.
  - `AGENTS.md` lists the same seven `.ai/` files in the expected order.
  - `CLAUDE.md` and `opencode.md` have identical content.
  - When `templates/` exists, its file set matches `SCAFFOLD_FILES`.
  - When `templates/` exists, root `CLAUDE.md`, `AGENTS.md`, and `opencode.md`
    match their template copies.
- Strict check intentionally skips template sync checks for normal downstream
  repositories that do not contain a `templates/` directory.
- `.ai/review-checklist.md` now matches the real repo state: scaffold changes
  are verified by the Bash integration suite plus base and strict self-checks.

## Current state

The project now has an automated check for the memory-sync invariant across
OpenCode, Claude Code, and Codex. The invariant is no longer only documented
or manually testable; `repomemo check --strict` can catch adapter drift and
template/file-list mismatch locally and in formula tests.

## Unresolved unknowns

Distribution publishing state was not changed or externally verified in this
task. The existing version remains `1.1.0`; decide separately whether this CLI
feature should trigger a version bump before release.

## Next safe action

Review the diff, then decide whether to keep this as an unreleased local change
or bump the version and prepare a release.
