# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Add OpenCode as a first-class supported agent alongside Claude Code and Codex.

OpenCode auto-loads `CLAUDE.md` by default, but repomemo now ships a dedicated
`opencode.md` adapter (identical `@-import` pattern to `CLAUDE.md`) so that
OpenCode users see explicit, first-class support in every scaffolded repository.
The scaffold grows from 9 files to 10 (7 under `.ai/` plus 3 root adapters).

## Files changed

- `opencode.md` (new) — root adapter for OpenCode, `@./path` imports.
- `templates/opencode.md` (new) — template copy shipped to users by `init`.
- `bin/repomemo` — added `"opencode.md"` to `SCAFFOLD_FILES`; version bumped
  to `1.1.0`; header comment updated.
- `tests/test_repomemo.sh` — `EXPECTED_VERSION` bumped; `opencode.md` added
  to `EXPECTED_FILES`; count assertions updated from `9` to `10`.
- `homebrew/repomemo.rb` — version, url tag bumped to `v1.1.0`;
  `opencode.md` added to test-block existence assertions; SHA256 set to
  `PLACEHOLDER_UPDATE_AFTER_RELEASE` (real value pinned after release).
- `package.json` — version bumped to `1.1.0`; `opencode` added to keywords.
- `README.md`, `README.zh.md` — every mention of "two adapters" updated to
  "three adapters"; `opencode.md` added to all code blocks, quick-start,
  what-it-generates, supported-agents, and paste-a-prompt sections.
- `.ai/README.md` — "two root adapters" → "three root adapters".
- `.ai/project.md` — purpose and non-goals updated to mention three adapters.
- `.ai/architecture.md` — repository layout tree updated; `templates/`
  description mentions three root adapters; data-flow diagram updated.
- `.ai/definition-of-done.md` — root-adapter sync rule expanded to three;
  template-sync rule expanded.
- `.ai/memory.md` — adapter conventions, version-bump checklist, and common
  pitfalls updated for three adapters.
- `.ai/handoff.md` — this file.

## Commands run

- `bash tests/test_repomemo.sh` → 8/8 PASS
- `bash bin/repomemo check .` → 10/10 PASS
- `git status` → clean before this commit.

## Checks performed

- No stale `9 created` / `9 skipped` / `9 overwritten` strings remain in
  `tests/test_repomemo.sh`.
- `grep -rn "two root adapters"` returns nothing.
- `grep -rn "two adapters"` returns nothing.
- `grep -rn "both adapters"` returns nothing.
- `grep -rn "TODO"` and `grep -rn "TBD"` inside `.ai/` return nothing.
- Integration suite green.
- Self-check green.

## Current state

- The repo supports three root adapters: `CLAUDE.md`, `AGENTS.md`,
  `opencode.md`.
- All documentation (`.ai/`, `README.md`, `README.zh.md`) is consistent with
  the three-adapter design.
- The GitHub repository is already renamed to `SUN-1024/repomemo`.
- The Homebrew tap `SUN-1024/homebrew-repomemo` exists and contains the v1.0.1
  formula; it needs the v1.1.0 formula after the release is published.

## Unresolved unknowns

- A `v1.1.0` release must be cut and its tarball SHA256 captured before the
  Homebrew formula can reference a real hash.
- `npm publish` is still pending (no npm account configured).

## Next safe action

For the maintainer:

1. Commit and push the current change to `origin/main`.
2. Push tag `v1.1.0` to trigger the GitHub Actions release workflow.
3. Copy the SHA256 from the release workflow output into
   `homebrew/repomemo.rb` and push the updated formula to
   `SUN-1024/homebrew-repomemo`.
