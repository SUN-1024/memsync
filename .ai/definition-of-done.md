# Definition of Done

This repository is markdown-only. There is no build, no test runner, no
linter, and no formatter configured. "Done" is therefore defined in terms of
documentation completeness, internal consistency, and agent readability.

## Required commands

None defined in this repository. There is no `package.json`, `Makefile`,
`pyproject.toml`, or equivalent.

If a downstream project adopts this scaffold, that project should record its
own build / test / lint / typecheck / format commands here, replacing this
section.

## A change is "done" when

1. **All seven `.ai/` files exist and are non-empty.**
   - `README.md`, `project.md`, `architecture.md`, `definition-of-done.md`,
     `review-checklist.md`, `memory.md`, `handoff.md`.
2. **Both root adapters exist and stay in sync.**
   - `CLAUDE.md` lists every `.ai/` file via `@./path` imports in the read
     order defined by `.ai/README.md`.
   - `AGENTS.md` lists the same files in the same order, plus the post-task
     update rule.
3. **Both READMEs exist and cross-link.**
   - `README.md` (English) links to `README.zh.md`.
   - `README.zh.md` (Simplified Chinese) links back to `README.md`.
4. **`handoff.md` reflects the change just made.**
   - Latest task, files changed, commands run, checks performed, current state,
     unresolved unknowns, next safe action.
5. **No placeholder text** (`TODO`, `TBD`, `Lorem ipsum`, `<placeholder>`,
   `XXX`) inside `.ai/`. If a fact is genuinely undefined, the file should
   say so in one clear sentence.
6. **`LICENSE` is present and unmodified** (unless the change is licensing
   itself).
7. **No secrets, tokens, or private URLs** committed anywhere.

## Review expectations

- Diffs touching `.ai/architecture.md` or `.ai/project.md` should be
  cross-checked against the actual repo state — these files describe the
  repository and must not lie.
- Diffs touching `CLAUDE.md` and `AGENTS.md` should land **together** when the
  read order or file list changes.
- Diffs touching `README.md` should be mirrored in `README.zh.md` (or vice
  versa) in the same PR.

## Verification

Manual, by reading the files. There is no automated check. A future iteration
could add `markdownlint-cli` and a link checker; neither is configured today.
